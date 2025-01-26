import C_GLAD

extension Texture {
    struct MagFilter: GLConstantRepresentable, TextureParameterI {
        let gl: Int32

        static let nearest = m(GL_NEAREST)
        static let linear = m(GL_LINEAR)
    }
}

extension Texture {
    struct MinFilter: GLConstantRepresentable, TextureParameterI {
        let gl: Int32

        static let nearest = m(GL_NEAREST)
        static let linear = m(GL_LINEAR)
        static let nearestMipmapNearest = m(GL_NEAREST_MIPMAP_NEAREST)
        static let linearMipmapNearest = m(GL_LINEAR_MIPMAP_NEAREST)
        static let nearestMipmapLinear = m(GL_NEAREST_MIPMAP_LINEAR)
        static let linearMipmapLinear = m(GL_LINEAR_MIPMAP_LINEAR)
    }
}
