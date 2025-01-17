import C_GLAD

struct ShaderType: GLConstantRepresentable {
    let gl: UInt32

    static let vertex = m(GL_VERTEX_SHADER)
    static let fragment = m(GL_FRAGMENT_SHADER)
}