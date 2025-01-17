import C_GLAD

struct GLPolygonMode: GLConstantRepresentable {
    let gl: UInt32

    static let point = m(GL_POINT)
    static let line = m(GL_LINE)
    static let fill = m(GL_FILL)
}
