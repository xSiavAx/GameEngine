protocol GLType {
    static var glVal: UInt32 { get }
}

extension GLType {
    static var size: Int { MemoryLayout<Self>.size }
    static var glSize: Int32 { Int32(size) }
}

// struct GLType {
//     let value: UInt32
//     let type: GLDataType.Type
//     var glType: UInt32 { type.glType }

//     static let float = m(C_GL_FLOAT, Float.self)
//     static let uInt = m(C_GL_UNSIGNED_INT, UInt32.self)

//     private static func m<T: GLDataType>(_ val: UInt32, _ type: T.Type) -> GLType {
//         return GLType(value: val, type: type)
//     }
// }

extension UInt32: GLType {
    static let glVal = C_GL_UNSIGNED_INT
}

extension Float: GLType {
    static let glVal = C_GL_FLOAT
}
        