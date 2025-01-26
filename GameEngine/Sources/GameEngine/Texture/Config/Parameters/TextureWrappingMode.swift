import C_GLAD

extension Texture {
    struct WrappingMode: GLConstantRepresentable, TextureParameterI {
        let gl: Int32

        static let `repeat` = m(GL_REPEAT)
        static let mirroredRepeat = m(GL_MIRRORED_REPEAT)
        static let clampToEdge = m(GL_CLAMP_TO_EDGE)
        static let clampToBorder = m(GL_CLAMP_TO_BORDER)
    }
}