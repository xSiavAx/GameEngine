import C_GLAD

// wtf???
let C_GL_TRUE = UInt8(GL_TRUE)
let C_GL_FALSE = UInt8(GL_FALSE)

extension Bool {
    var gl: UInt8 { UInt8(self ? GL_TRUE : GL_FALSE) }
    var asInt32: Int32 { self ? 1 : 0 }
}
