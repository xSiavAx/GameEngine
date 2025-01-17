import C_GLAD

struct BufferType: GLConstantRepresentable {
    let gl: UInt32

    static let array = m(GL_ARRAY_BUFFER)
    static let elementsArray = m(GL_ELEMENT_ARRAY_BUFFER)
}