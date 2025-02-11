import simd

protocol VertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: VertexAttributeLocation) -> BoundVertexAttribute
}

protocol ComponentsContainer {
    static var componentsCount: Int { get }
}

extension Float: VertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: VertexAttributeLocation) -> BoundVertexAttribute {
        return BoundVertexAttribute(shouldNormilize: shouldNormilize, location: location, componentsCount: 1, size: size, type: glVal)
    }
}

extension SIMD2: ComponentsContainer { static var componentsCount: Int { 2 } }
extension SIMD3: ComponentsContainer { static var componentsCount: Int { 3 } }
extension SIMD4: ComponentsContainer { static var componentsCount: Int { 4 } }

extension SIMD2: VertexAttributeType where Scalar: VertexAttributeType {}
extension SIMD3: VertexAttributeType where Scalar: VertexAttributeType {}
extension SIMD4: VertexAttributeType where Scalar: VertexAttributeType {}

extension SIMD where Self: ComponentsContainer, Scalar: VertexAttributeType {
    static func makeBound(shouldNormilize: Bool, location: VertexAttributeLocation) -> BoundVertexAttribute {
        var base = Scalar.makeBound(shouldNormilize: shouldNormilize, location: location)

        base.componentsCount = componentsCount
        base.size *= componentsCount

        return base
    }
}
