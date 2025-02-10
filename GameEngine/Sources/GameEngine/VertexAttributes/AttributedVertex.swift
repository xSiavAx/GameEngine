import C_GLAD

protocol ComponentsContainer {
    static var componentsCount: Int { get }
}

extension SIMD2: ComponentsContainer {
    static var componentsCount: Int { 2 }
}

extension SIMD3: ComponentsContainer {
    static var componentsCount: Int { 3 }
}

extension SIMD4: ComponentsContainer {
    static var componentsCount: Int { 4 }
}

protocol VertexAttribute: ComponentsContainer {
    static var rawSize: Int { get }
    static var glVal: UInt32 { get }

    func pack(into ptr: inout UnsafeMutableRawPointer)
}

extension VertexAttribute {
    static func enable(location: Int) {
        c_glEnableVertexAttribArray(UInt32(location))
    }
}

extension SIMD where Self: ComponentsContainer, Scalar: GLType {
    static var rawSize: Int { componentsCount * Scalar.size }
}

extension SIMD2: VertexAttribute where Scalar: GLType {}
extension SIMD3: VertexAttribute where Scalar: GLType {}
extension SIMD4: VertexAttribute where Scalar: GLType {}

protocol AttributedVertex {
    static var attributes: [VertexAttribute.Type] { get }

    var attributes: [VertexAttribute] { get }
}

extension AttributedVertex {
    static var rawSize: Int { attributes.map { $0.rawSize }.reduce(0, +) }

    func pack(into ptr: inout UnsafeMutableRawPointer) {
        for attribute in attributes {
            attribute.pack(into: &ptr)
        }
    }

    static func linkAttributes(
        shouldNormilize: Bool,
        _ block: (_ location: Int, _ attribute: VertexAttribute.Type) -> Void
    ) {
        var offset = UnsafeMutableRawPointer(bitPattern: 0x1)! - 1
        let stride = Int32(rawSize)

        for (location, attributeType) in attributes.enumerated() {
            c_glVertexAttribPointer(
                UInt32(location), // location for pos (sepcified in VertexShader.gs)
                Int32(attributeType.componentsCount),
                attributeType.glVal,
                shouldNormilize.gl,
                stride, // size of vertext (all components)
                offset
            )
            offset += attributeType.rawSize
            block(location, attributeType)
        }
    }
}

enum VertexPacker {
    static func withPacked<V: AttributedVertex>(
        vertices: [V],
        _ block: (_ address: UnsafeRawPointer, _ size: Int) -> Void
    ) {
        let size = vertices.count * V.rawSize
        let bytesPtr = UnsafeMutableRawPointer.allocate(byteCount: size, alignment: 1)
        var offsetPtr = bytesPtr

        defer { bytesPtr.deallocate() }

        for vertex in vertices {
            vertex.pack(into: &offsetPtr)
        }
        block(bytesPtr, size)
    }
}
