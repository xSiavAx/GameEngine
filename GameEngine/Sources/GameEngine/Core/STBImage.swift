import C_STB_Image
import Foundation
import MapReduce

struct STBImage {
    var width: Int
    var height: Int
    var channels: Int
    var data: Data

    static func load(url: URL) throws -> STBImage {
        return try url.map(UrlToSTBImage()).get()
    }

    static func load(resource: ResourceReference) throws -> STBImage {
        let url = try resource.map(ResourceReferenceToUrl()).get()
        return try load(url: url)
    }
}

struct UnsafeSTBData {
    var width: UInt32 = 0
    var height: UInt32 = 0
    var channels: UInt32 = 0
    var bytes: UnsafeRawPointer
    var count: Int { Int(width * height * channels) }
}

enum STBReadError: Error {
    case invalidImage(String) // Image is corrupted, invalid or memory allocation error
}

struct STBRead {
    let path: String
    let flipVertically: Bool

    init(path: String, flipVertically: Bool = true) {
        self.path = path
        self.flipVertically = flipVertically
    }

    func withUnsafeBytes<T>(_ handle: (UnsafeSTBData) throws -> T) throws -> T {
        var width: UInt32 = 0
        var height: UInt32 = 0
        var channels: UInt32 = 0

        stbi_set_flip_vertically_on_load(flipVertically.asInt32)
        guard let bytes = stbi_load(path, &width, &height, &channels, 0) else {
            throw STBReadError.invalidImage(path)
        }
        defer { stbi_image_free(bytes) }

        return try handle(UnsafeSTBData(width: width, height: height, channels: channels, bytes: bytes))
    }
}

final class UrlToSTBImage: Mapper {
    func map(_ url: URL) -> Result<STBImage, Error> {
        return Result { try make(url) }
    }

    private func make(_ url: URL) throws -> STBImage {
        return try STBRead(path: url.path).withUnsafeBytes { data in
            return STBImage(
                width: Int(data.width),
                height: Int(data.height),
                channels: Int(data.channels),
                data: Data(bytes: data.bytes, count: data.count)
            ) 
        }
    }
}

