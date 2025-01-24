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
        // TODO: Add unbind?
        // OR replace it by `withBind(_ handler:)`?
        c_glBindTexture(type.gl, id)
    }

    // Add config
    // glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    // glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    // glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
    // glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

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

    static func allocateID() -> UInt32? {
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
    case invalidMimapLevel
    case sourceDidNotSet
    case unxpectedNumberOfChannlesInSource(Int, expected: Int)
    case textureTypeDoesntSupportImage2D
    case textureTypeDoesntSupportMipmap
}
