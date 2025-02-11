import C_GLAD

struct BoundVertexAttribute {
    var shouldNormilize: Bool
    var location: VertexAttributeLocation
    var componentsCount: Int
    var size: Int
    var type: UInt32

    func link(stride: Int32, offset: UnsafeMutableRawPointer) {
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
        c_glEnableVertexAttribArray(location.rawValue)
    }
}

extension Array where Element == BoundVertexAttribute {
    var stride: Int { return map(\.size).reduce(0, +) }
}
