import Foundation
import C_STB_Image
import C_GLAD

final class Texture {
    let id: UInt32
    let type: TextureType
    let internalFormat: InternalFormat
    let format: Format

    private var isSourceSet = false

    init?(type: TextureType, internalFormat: InternalFormat, format: Format) {
        guard let id = Self.allocateID() else { return nil }
        self.id = id
        self.type = type
        self.internalFormat = internalFormat
        self.format = format
    }

    func bind() {
        c_glBindTexture(type.gl, id)
    }

    func unbind() {
        c_glBindTexture(type.gl, 0)
    }

    func withBind(_ handler: () throws -> Void) rethrows {
        bind()
        defer { unbind() }
        try handler()
    }

    func set(source: URL, mipMapLevel: Int = 0) throws {
        try STBRead(path: source.path).withUnsafeBytes { data in
            let channels = Int(data.channels)

            guard Int(channels) == format.channels else { throw TextureError.unxpectedNumberOfChannlesInSource(channels, expected: channels) }
            guard type.isImage2D else { throw TextureError.textureTypeDoesntSupportImage2D }
            guard !type.isRectangle || mipMapLevel == 0 else { throw TextureError.invalidMimapLevel }

            c_glTexImage2D(
                type.gl,
                Int32(mipMapLevel),
                internalFormat.gl,
                Int32(data.width),
                Int32(data.height),
                0, // Border. Legacy. Must be 0.
                format.gl,
                PixelDataType.unsignedByte.gl,
                data.bytes
            )
        }
        isSourceSet = true
    }

    @discardableResult
    func config(_ c: TextureConfig) -> Texture {
        c.apply(type: type)
        return self
    }

    func generateMipmpap() throws {
        guard isSourceSet else { throw TextureError.sourceDidNotSet }
        guard type.supportsMipmap else { throw TextureError.textureTypeDoesntSupportMipmap }
        c_glGenerateMipmap(type.gl)
    }

    func set(source: ResourceReference, mipMapLevel: Int = 0) throws {
        let url = try source.map(ResourceReferenceToUrl()).get()

        try set(source: url, mipMapLevel: mipMapLevel)
    }

    func setSource(resource: String, mipMapLevel: Int = 0) throws {
        try set(source: ResourceReference(name: resource), mipMapLevel: mipMapLevel)
    }

    static func make(
        resource: String, 
        type: TextureType = .t2D, 
        internalFormat: InternalFormat = .Base.rgb, 
        format: Format = .rgb,
        wrapping: WrappingMode,
        generateMipmpap: Bool = true
    ) throws -> Texture? {
        guard let texture = Texture(
            type: type, 
            internalFormat: 
            internalFormat, format: format
        ) else { throw TextureError.cantAllocateTextureID }

        try texture.withBind {
            texture.config(.wrap(s: wrapping, t: wrapping))
            if generateMipmpap {
                texture.config(.filter(min: .linearMipmapLinear, mag: .linear))
            }
            try texture.setSource(resource: resource)
            if generateMipmpap {
                try texture.generateMipmpap()
            }
        }

        return texture
    }

    private static func allocateID() -> UInt32? {
        var id: UInt32 = 0;

        c_glGenTextures(1, &id)

        return id != 0 ? id : nil
    }
    
    deinit {
        var id = id
        c_glDeleteTextures(1, &id)
    }
}

enum TextureError: Error {
    case cantAllocateTextureID
    case invalidMimapLevel
    case sourceDidNotSet
    case unxpectedNumberOfChannlesInSource(Int, expected: Int)
    case textureTypeDoesntSupportImage2D
    case textureTypeDoesntSupportMipmap
}
