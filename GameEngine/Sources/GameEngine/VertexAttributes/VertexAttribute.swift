import simd

struct VertexAttribute<T: VertexAttributeType> {
    let location: VertexAttributeLocation

    static func va(_ location: VertexAttributeLocation) -> VertexAttribute<T> {
        return .init(location: location)
    }
}

extension VertexAttribute where T == SIMD3<Float> {
    static let position = va(.position)
    static let normal = va(.normal)
    static let color = va(.color)
}

extension VertexAttribute where T == SIMD2<Float> {
    static let texture = va(.textureCoord)
}
