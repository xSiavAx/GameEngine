import simd

struct Vertex: PackingVertex, Sendable {
    nonisolated(unsafe) static let attributes: [KeyPath<Vertex, any PackingBoundVertexAtttribute>] = [
        \.$position,
        \.$texture,
        \.$normal,
        \.$color,
    ]

    @VertexAttributeWrapper(shouldNormilize: false, attribute: .position)
    var position: SIMD3<Float> = .zero

    @VertexAttributeWrapper(shouldNormilize: false, attribute: .texture)
    var texture: SIMD2<Float> = .zero

    @VertexAttributeWrapper(shouldNormilize: false, attribute: .normal)
    var normal: SIMD3<Float> = .zero

    @CustomVertexAttributeWrapper(shouldNormilize: false, attribute: .color)
    var color: Color = .white
}
