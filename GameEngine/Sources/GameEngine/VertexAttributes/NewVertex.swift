import simd
import C_GLAD

enum NewVertexAttributeLocation: UInt32 {
    case position = 0
    case textureCoord = 1
    case normal = 2
    case color = 3
}

protocol NewVertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: NewVertexAttributeLocation) -> BoundAttribute
}

extension Float: NewVertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: NewVertexAttributeLocation) -> BoundAttribute {
        return BoundAttribute(shouldNormilize: shouldNormilize, location: location, componentsCount: 1, size: size, type: glVal)
    }
}

extension SIMD2: NewVertexAttributeType where Scalar: NewVertexAttributeType {}
extension SIMD3: NewVertexAttributeType where Scalar: NewVertexAttributeType {}
extension SIMD4: NewVertexAttributeType where Scalar: NewVertexAttributeType {}

extension SIMD2: PackingVertexAtttribute where Scalar: GLType {}
extension SIMD3: PackingVertexAtttribute where Scalar: GLType {}
extension SIMD4: PackingVertexAtttribute where Scalar: GLType {}

extension SIMD where Scalar: GLType {
    static var glVal: UInt32 { Scalar.glVal }

    func pack(into ptr: inout UnsafeMutableRawPointer) {
        for i in (0..<scalarCount) {
            ptr.storeBytes(of: self[i], as: Scalar.self)
            ptr += Scalar.size
        }
    }
}

extension SIMD where Self: ComponentsContainer, Scalar: NewVertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: NewVertexAttributeLocation) -> BoundAttribute {
        var base = Scalar.makeBound(shouldNormilize: shouldNormilize, location: location)

        base.componentsCount = componentsCount
        base.size *= componentsCount

        return base
    }
}

struct NewVertexAttribute<T: NewVertexAttributeType> {
    let location: NewVertexAttributeLocation

    static func va(_ location: NewVertexAttributeLocation) -> NewVertexAttribute<T> {
        return .init(location: location)
    }
}

extension NewVertexAttribute {

}

extension NewVertexAttribute where T == SIMD3<Float> {
    static let position = va(.position)
    static let normal = va(.normal)
    static let color = va(.color)
}

extension NewVertexAttribute where T == SIMD2<Float> {
    static let texture = va(.textureCoord)
}

struct BoundAttribute {
    var shouldNormilize: Bool
    var location: NewVertexAttributeLocation
    var componentsCount: Int
    var size: Int
    var type: UInt32
}

struct LinkAttribute {
    let enabled: Bool
    let attribute: BoundAttribute

    func linkAndEnableIfNeeded(stride: Int32, offset: UnsafeMutableRawPointer) {
        print(enabled)
        
        if enabled {
            attribute.link(stride: stride, offset: offset)
            attribute.enable()
        }
    }
}

extension Array where Element == BoundAttribute {
    var stride: Int { return map(\.size).reduce(0, +) }
}

extension BoundAttribute {
    func link(stride: Int32, offset: UnsafeMutableRawPointer) {
        print("Link stride \(stride) offset \(offset) location \(location) components count \(componentsCount) type \(type)")
        c_glVertexAttribPointer(
            location.rawValue, // location for pos (sepcified in VertexShader.gs)
            Int32(componentsCount),
            type,
            shouldNormilize.gl,
            stride, // size of vertext (all components)
            offset
        )
    }

    func enable() {
        print("Enable \(location.rawValue)")
        c_glEnableVertexAttribArray(location.rawValue)
    }
}

extension Array where Element == LinkAttribute {
    func link() {
        var offset = UnsafeMutableRawPointer(bitPattern: 0x1)! - 1
        let stride = Int32(map(\.attribute).stride)

        for bound in self {
            defer { offset += bound.attribute.size }
            bound.linkAndEnableIfNeeded(stride: stride, offset: offset)
        }
    }
}

protocol PackingVertex {
    static var attributes: [KeyPath<Self, any PackingBoundVertexAtttribute>] { get }
}

protocol PackingVertexAtttribute {
    func pack(into: inout UnsafeMutableRawPointer)
}

protocol PackingBoundVertexAtttribute {
    var bound: BoundAttribute { get }
    var value: PackingVertexAtttribute { get }
}

final class NewVertexPacker {
    static func pack<T: PackingVertex>(
        _ vertices: [T], 
        properties: [KeyPath<T, PackingBoundVertexAtttribute>],
        _ block: (_ address: UnsafeRawPointer, _ size: Int) -> Void
    ) -> [LinkAttribute]? {
        let filtered = vertices.map { vertex in properties.map { vertex[keyPath: $0] } }
        guard let first = filtered.first else { return nil }
        let links = first.map { $0.bound }
        let size = vertices.count * links.stride
        let bytesPtr = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: 1)
        var offsetPtr = bytesPtr

        defer { bytesPtr.deallocate() }

        for properties in filtered {
            for property in properties {
                property.value.pack(into: &offsetPtr)
            }
        }
        
        let vertex = vertices.first!

        block(bytesPtr, size)
        return T.attributes.map {
            return LinkAttribute(enabled: properties.contains($0), attribute: vertex[keyPath: $0].bound)
        }
    }
}

struct NewVertex: PackingVertex {
    nonisolated(unsafe) static let attributes: [KeyPath<NewVertex, any PackingBoundVertexAtttribute>] = [
        \.$position,
        \.$texture,
        \.$normal,
        \.$color,
    ]

    @NewVertexAttributeWrapper(shouldNormilize: false, attribute: .position)
    var position: SIMD3<Float> = .zero

    @NewVertexAttributeWrapper(shouldNormilize: false, attribute: .texture)
    var texture: SIMD2<Float> = .zero

    @NewVertexAttributeWrapper(shouldNormilize: false, attribute: .normal)
    var normal: SIMD3<Float> = .zero

    @NewCustomVertexAttributeWrapper(shouldNormilize: false, attribute: .color)
    var color: Color = .white
}

@propertyWrapper 
struct NewVertexAttributeWrapper<T: PackingVertexAtttribute & NewVertexAttributeType>: PackingBoundVertexAtttribute {
    var wrappedValue: T
    let shouldNormilize: Bool
    let attribute: NewVertexAttribute<T>

    var projectedValue: PackingBoundVertexAtttribute { self }

    var bound: BoundAttribute { T.makeBound(shouldNormilize: shouldNormilize, location: attribute.location) }
    var value: PackingVertexAtttribute { wrappedValue }
}

@propertyWrapper 
struct NewCustomVertexAttributeWrapper<T: VertexAtttributeRepresentable>: PackingBoundVertexAtttribute {
    var wrappedValue: T
    let shouldNormilize: Bool
    let attribute: NewVertexAttribute<T.T>

    var projectedValue: PackingBoundVertexAtttribute { self }

    var bound: BoundAttribute { T.T.makeBound(shouldNormilize: shouldNormilize, location: attribute.location) }
    var value: PackingVertexAtttribute { wrappedValue.asVertexAttribute }
}

protocol VertexAtttributeRepresentable {
    associatedtype T: PackingVertexAtttribute & NewVertexAttributeType

    var asVertexAttribute: T { get } 
}

extension Color: VertexAtttributeRepresentable {
    var asVertexAttribute: SIMD3<Float> { rgbVector }
}

final class TestScene: Scene {
    let vao = VertexArraySingle()
    let vbo = GLBufferSingle(type: .array)
    let vertices = [
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, -0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, -0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, -0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, -0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),

        NewVertex(position: SIMD3<Float>(-0.5, -0.5, 0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, 0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, 0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, 0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),

        NewVertex(position: SIMD3<Float>(-0.5, 0.5, 0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, -0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, 0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, 0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),

        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, -0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, -0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, -0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, 0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),

        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, -0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, 0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(0.5, -0.5, 0.5), texture: SIMD2<Float>(1.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .green),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, 0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),
        NewVertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), texture: SIMD2<Float>(0.0, 0.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .red),

        NewVertex(position: SIMD3<Float>(-0.5, 0.5, -0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, -0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(0.5, 0.5, 0.5), texture: SIMD2<Float>(1.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .blue),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, 0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow),
        NewVertex(position: SIMD3<Float>(-0.5, 0.5, -0.5), texture: SIMD2<Float>(0.0, 1.0), normal: SIMD3<Float>(0.0, 0.0, 1.0), color: .yellow)
    ]
    private let cameraHelper = CameraHelper(transform: LookAtTransform(position: .zero, front: .frontR))

    func prepare(context: Context, window: Window, shaderProgram: ShaderProgram) throws {
        try cameraHelper.config(shaderProgram: shaderProgram, viewPort: context.$viewPort)
        cameraHelper.bindInput(window.inputProcessor)

        try shaderProgram.getUniform(name: "model").set(simd_float4x4.identity)
        try shaderProgram.getUniform(name: "lightColor").set(Color.white.rgbVector)
        
        vao.bind { vaoName in
            vbo.bind { buffer in
                let links = buffer.add(vertices: vertices, usage: .staticDraw)!
                
                links.link()
                vaoName.setDrawer(ArraysVertexArrayDrawer(mode: .triangles, first: 0, count: vertices.count))
            }
        }
        try shaderProgram.modeUniform().set(.color)
    }
    
    func draw(delta: Float) throws {
        try vao.draw()
        cameraHelper.update(delta: delta)
    }
}

extension GLBufferName {
    func add<V: PackingVertex>(
        vertices: [V],
        properties: [KeyPath<V, PackingBoundVertexAtttribute>] = V.attributes,
        usage: GLBufferDataUsage = .staticDraw
    ) -> [LinkAttribute]? {
        NewVertexPacker.pack(vertices, properties: properties) { address, size in
            c_glBufferData(type.gl, GLsizeiptr(size), address, usage.gl)
        }
    }
}