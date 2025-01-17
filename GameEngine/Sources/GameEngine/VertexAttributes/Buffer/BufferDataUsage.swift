import C_GLAD

struct GLBufferDataUsage: GLConstantRepresentable {
    let gl: UInt32
    
    static let dynamicDraw = m(GL_DYNAMIC_DRAW)
    static let staticDraw = m(GL_STATIC_DRAW)
}
