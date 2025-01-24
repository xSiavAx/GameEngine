protocol GLConstantRepresentable: Equatable {
    var gl: UInt32 { get }

    init(gl: UInt32)
}

extension GLConstantRepresentable {
    static func m(_ val: Int32) -> Self {
        return .init(gl: UInt32(val))
    }
}
