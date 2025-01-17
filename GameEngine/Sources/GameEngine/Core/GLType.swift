import C_GLAD

protocol GLType {
    static var glVal: UInt32 { get }
}

extension GLType {
    static var size: Int { MemoryLayout<Self>.size }
    static var glSize: Int32 { Int32(size) }
}

extension UInt32: GLType {
    static let glVal = UInt32(GL_UNSIGNED_INT)
}

extension Float: GLType {
    static let glVal = UInt32(GL_FLOAT)
}

extension Bool: GLType {
    static let glVal = UInt32(GL_BOOL)
}