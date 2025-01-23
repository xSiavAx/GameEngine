import C_STB_Image

struct STBImage {
    var width: Int
    var height: Int
    var channels: Int
    var data: Data
}

import Foundation

protocol STBImageLoader {
    func load() throws -> STBImage
}

enum STBImageLoadError: Error {
    case invalidImage(String) // Image is corrupted, invalid or memory allocation error
}

final class DefaultSTBImageLoader {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() throws -> STBImage {
        var width: UInt32 = 0
        var height: UInt32 = 0
        var channels: UInt32 = 0

        guard let bytes = stbi_load(url.path, &width, &height, &channels, 0) else {
            throw STBImageLoadError.invalidImage(url.path)
        }
        defer { stbi_image_free(bytes) }
        let data = Data(bytes: bytes, count: Int(width * height * channels))

        return STBImage(
            width: Int(width),
            height: Int(height),
            channels: Int(channels),
            data: data
        )
    }
}
