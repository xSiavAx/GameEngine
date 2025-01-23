import Foundation

protocol ResourceURLProvider {
    func url(name: String, ext: String?) -> URL?
}

enum ResourceURLProviderError: Error {
    case resoruceNotFound(String?, String?)
}

extension ResourceURLProvider {
    func requiredURL(name: String, ext: String?) throws -> URL {
        guard let url = url(name: name, ext: ext) else {
            throw ResourceURLProviderError.resoruceNotFound(name, ext)
        }
        return url
    }

    func requiredURL(name: String) throws -> URL {
        let (name, ext) = name.nameAndExtension
        return try requiredURL(name: name, ext: ext)
    }

    func url(name: String) -> URL? {
        let (name, ext) = name.nameAndExtension

        return url(name: name, ext: ext)
    }
}

private extension String {
    var nameAndExtension: (String, String?) {
        let components = split(separator: ".")
        return (String(components[0]), components.last.flatMap { String($0) })
    }
}

// final class BundleURLProvider: ResourceURLProvider {
//     func url(name: String, ext: String?) -> URL? {
//         return Bundle.module.url(forResource: name, withExtension: ext)
//     }
// }