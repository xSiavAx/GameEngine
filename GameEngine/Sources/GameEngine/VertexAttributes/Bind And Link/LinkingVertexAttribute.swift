struct LinkingVertextAttribute {
    let enabled: Bool
    let attribute: BoundVertexAttribute

    func linkAndEnableIfNeeded(stride: Int32, offset: UnsafeMutableRawPointer) {
        if enabled {
            attribute.link(stride: stride, offset: offset)
            attribute.enable()
        }
    }
}


extension Array where Element == LinkingVertextAttribute {
    func linkAndAnable() {
        var offset = UnsafeMutableRawPointer(bitPattern: 0x1)! - 1
        let stride = Int32(map(\.attribute).stride)

        for bound in self {
            defer { offset += bound.attribute.size }
            bound.linkAndEnableIfNeeded(stride: stride, offset: offset)
        }
    }
}