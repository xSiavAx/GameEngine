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

enum STBImageLoadError: Error {
    case invalidImage(String) // Image is corrupted, invalid or memory allocation error
}

final class UrlToSTBImage: FailingMapper {
    func map(_ url: URL) -> Result<STBImage, Error> {
        return Result { try make(url) }
    }

    private func make(_ url: URL) throws(STBImageLoadError) -> STBImage {
        var width: UInt32 = 0
        var height: UInt32 = 0
        var channels: UInt32 = 0

        guard let bytes = stbi_load(url.path, &width, &height, &channels, 0) else {
            throw STBImageLoadError.invalidImage(url.path)
        }
        defer { stbi_image_free(bytes) }

        return STBImage(
            width: Int(width),
            height: Int(height),
            channels: Int(channels),
            data: Data(bytes: bytes, count: Int(width * height * channels))
        )
    }
}
