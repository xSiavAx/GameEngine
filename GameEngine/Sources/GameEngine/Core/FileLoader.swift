import Foundation

protocol FileLoad: ObjectLoad {
    func callAsFunction() throws -> Data
}

final class DefaultFileLoad: FileBasedObjectLoad<Data, DataLoader>, FileLoad {
    static func with(url: URL) -> DefaultFileLoad {
        return DefaultFileLoad(url: url, map: DataLoader())
    }

    static func with(bundleResource: (name: String, ext: String?)) -> DefaultFileLoad {
        return DefaultFileLoad(url: BundleURLProvider(name: bundleResource.name, ext: bundleResource.ext), map: DataLoader())
    }

    static func with(bundleResource: String) -> DefaultFileLoad {
        return DefaultFileLoad(url: BundleURLProvider(name: bundleResource), map: DataLoader())
    }
}
