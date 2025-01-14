import Foundation

protocol FileLoader: Sendable {
    func load() throws -> Data
}

final class DefaultFileLoader: FileLoader {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() throws -> Data {
        return try Data(contentsOf: url)
    }
}

enum BundleFileLoaderError: Error {
    case resoruceNotFound(String?, String?)
}

final class BundleFileLoader: FileLoader {
    let title: String?
    let ext: String?
    let fileLoader: DefaultFileLoader

    init(title: String, ext: String?) throws {
        guard let url = Bundle.module.url(forResource: title, withExtension: ext) else {
            throw BundleFileLoaderError.resoruceNotFound(title, ext)
        }
        self.title = title
        self.ext = ext
        self.fileLoader = DefaultFileLoader(url: url)
    }

    convenience init(name: String) throws {
        let components = name.split(separator: ".")

        try self.init(title: String(components[0]), ext: components.last.flatMap { String($0) } )
    }

    func load() throws -> Data {
        return try fileLoader.load()
    }
}
