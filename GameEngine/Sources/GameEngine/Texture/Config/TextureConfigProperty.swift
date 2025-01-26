import C_GLAD

struct TextureProperty: GLConstantRepresentable {
    let gl: UInt32

    static let wrapS = m(GL_TEXTURE_WRAP_S)
    static let wrapT = m(GL_TEXTURE_WRAP_T)
    static let minFilter = m(GL_TEXTURE_MIN_FILTER)
    static let magFilter = m(GL_TEXTURE_MAG_FILTER)
}
