protocol GLConstantRepresentable: Equatable {
    associatedtype T
    var gl: T { get }

    init(gl: T)
}

extension GLConstantRepresentable where T == UInt32 {
    static func m(_ val: Int32) -> Self {
        return .init(gl: UInt32(val))
    }
}

extension GLConstantRepresentable where T == Int32 {
    static func m(_ val: Int32) -> Self {
        return .init(gl: val)
    }
}
