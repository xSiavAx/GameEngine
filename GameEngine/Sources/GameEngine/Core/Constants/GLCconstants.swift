import C_GL
import C_GLAD

// BufferUsage
let C_GL_STATIC_DRAW = c(GL_STATIC_DRAW)

// wtf???
let C_GL_TRUE = UInt8(GL_TRUE)
let C_GL_FALSE = UInt8(GL_FALSE)

private func c(_ val: Int32) -> UInt32 {
    return UInt32(val)
}
