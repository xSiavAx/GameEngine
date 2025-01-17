import C_GL
import C_GLAD

// Shader Type
let C_GL_VERTEX_SHADER = c(GL_VERTEX_SHADER)
let C_GL_FRAGMENT_SHADER = c(GL_FRAGMENT_SHADER)

// Programm status
let C_GL_COMPILE_STATUS = c(GL_COMPILE_STATUS)
let C_GL_LINK_STATUS = c(GL_LINK_STATUS)

// ???
let C_GL_FRONT_AND_BACK = c(GL_FRONT_AND_BACK)
// BufferUsage
let C_GL_STATIC_DRAW = c(GL_STATIC_DRAW)

//PolygonMode
let C_GL_LINE = c(GL_LINE)
let C_GL_FILL = c(GL_FILL)

// wtf???
let C_GL_TRUE = UInt8(GL_TRUE)
let C_GL_FALSE = UInt8(GL_FALSE)

private func c(_ val: Int32) -> UInt32 {
    return UInt32(val)
}
