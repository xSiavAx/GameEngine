protocol VertexAtttributeRepresentable {
    associatedtype T: PackingVertexAtttribute & VertexAttributeType

    var asVertexAttribute: T { get } 
}

extension Color: VertexAtttributeRepresentable {
    var asVertexAttribute: SIMD3<Float> { rgbVector }
}
