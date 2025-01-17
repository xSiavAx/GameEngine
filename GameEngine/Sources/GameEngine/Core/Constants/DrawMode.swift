import C_GLAD

struct DrawMode: GLConstantRepresentable {
    let gl: UInt32

    static let triangles = m(GL_TRIANGLES)
}