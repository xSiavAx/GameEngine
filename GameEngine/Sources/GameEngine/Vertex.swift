import simd

struct Vertex: AttributedVertex {
    static let attributes: [VertexAttribute.Type] = [
        SIMD3<Float>.self, 
        SIMD3<Float>.self,
        SIMD2<Float>.self
    ]

    var attributes: [VertexAttribute] { [
        coords, 
        color.rgbVector,
        texture
    ]}

    let coords: SIMD3<Float>
    let color: Color
    let texture: SIMD2<Float>
}
