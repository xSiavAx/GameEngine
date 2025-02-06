import C_GLAD

let C_GL_DEPTH_BUFFER_BIT = GLbitfield(GL_DEPTH_BUFFER_BIT)
let C_GL_COLOR_BUFFER_BIT = GLbitfield(GL_COLOR_BUFFER_BIT)
let C_GL_DEPTH_TEST = GLenum(GL_DEPTH_TEST)

extension Bool {
    var gl: UInt8 { UInt8(self ? GL_TRUE : GL_FALSE) }
    var asInt32: Int32 { self ? 1 : 0 }
}
