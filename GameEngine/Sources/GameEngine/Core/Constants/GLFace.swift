import C_GLAD

struct GLFace: GLConstantRepresentable {
    let gl: UInt32

    static let frontAndBack = m(GL_FRONT_AND_BACK)
}
