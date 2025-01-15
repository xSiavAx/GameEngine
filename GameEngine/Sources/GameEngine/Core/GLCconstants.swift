import C_GL
import C_GLAD

let C_GL_ARRAY_BUFFER = c(GL_ARRAY_BUFFER)
let C_GL_STATIC_DRAW = c(GL_STATIC_DRAW)
let C_GL_VERTEX_SHADER = c(GL_VERTEX_SHADER)
let C_GL_FRAGMENT_SHADER = c(GL_FRAGMENT_SHADER)
let C_GL_COMPILE_STATUS = c(GL_COMPILE_STATUS)
let C_GL_LINK_STATUS = c(GL_LINK_STATUS)

let C_GL_FLOAT = c(GL_FLOAT)

let C_GL_TRUE = UInt8(GL_TRUE)
let C_GL_FALSE = UInt8(GL_FALSE)

private func c(_ val: Int32) -> UInt32 {
    return UInt32(val)
}
