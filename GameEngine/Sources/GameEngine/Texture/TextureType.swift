import C_GLAD
import C_GL

struct TextureType: GLConstantRepresentable {
    let gl: UInt32

    static let t1D = m(GL_TEXTURE_1D)
    static let t2D = m(GL_TEXTURE_2D)
    static let t3D = m(GL_TEXTURE_3D)
    static let array1D = m(GL_TEXTURE_1D_ARRAY)
    static let array2D = m(GL_TEXTURE_2D_ARRAY)
    static let rectangle = m(GL_TEXTURE_RECTANGLE)
    static let cubeMap = m(GL_TEXTURE_CUBE_MAP)
    static let cubeMapArray = m(GL_TEXTURE_CUBE_MAP_ARRAY)
    static let cubeMapPositiveX = m(GL_TEXTURE_CUBE_MAP_POSITIVE_X)
    static let cubeMapNegativeX = m(GL_TEXTURE_CUBE_MAP_NEGATIVE_X)
    static let cubeMapPositiveY = m(GL_TEXTURE_CUBE_MAP_POSITIVE_Y)
    static let cubeMapNegativeY = m(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y)
    static let cubeMapPositiveZ = m(GL_TEXTURE_CUBE_MAP_POSITIVE_Z)
    static let cubeMapNegativeZ = m(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z)
    static let buffer = m(GL_TEXTURE_BUFFER)
    static let multisample2D = m(GL_TEXTURE_2D_MULTISAMPLE)
    static let multisampleArray2D = m(GL_TEXTURE_2D_MULTISAMPLE_ARRAY)

    // proxy
    static let proxy2d = m(GL_PROXY_TEXTURE_2D)
    static let proxy1dArray = m(GL_PROXY_TEXTURE_1D_ARRAY)
    static let proxyRectangle = m(GL_PROXY_TEXTURE_RECTANGLE)
    static let proxyCubeMap = m(GL_PROXY_TEXTURE_CUBE_MAP)


    var isImage2D: Bool { Self.image2DFormats.contians(gl) }
    var supportsMipmap: Bool { Self.supportMipmapFormats.contians(gl) }

    var isRectangle: Bool { return self == .rectangle || self == .proxyRectangle }

    private static let image2DFormats = [
        GL_TEXTURE_2D,
        GL_PROXY_TEXTURE_2D,
        GL_TEXTURE_1D_ARRAY,
        GL_PROXY_TEXTURE_1D_ARRAY,
        GL_TEXTURE_RECTANGLE,
        GL_PROXY_TEXTURE_RECTANGLE,
        GL_TEXTURE_CUBE_MAP_POSITIVE_X,
        GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
        GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
        GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
        GL_TEXTURE_CUBE_MAP_POSITIVE_Z,
        GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,
        GL_PROXY_TEXTURE_CUBE_MAP,
    ]

    private static let supportMipmapFormats = [
        GL_TEXTURE_1D,
        GL_TEXTURE_2D,
        GL_TEXTURE_3D,
        GL_TEXTURE_1D_ARRAY,
        GL_TEXTURE_2D_ARRAY,
        GL_TEXTURE_CUBE_MAP,
        GL_TEXTURE_CUBE_MAP_ARRAY,
    ]
}
