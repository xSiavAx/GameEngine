import Foundation

protocol ObjectLoad {
    associatedtype O

    func callAsFunction() throws -> O
}

protocol FileURLProvider: Sendable {
    func callAsFunction() -> URL?
}

protocol Mapper {
    associatedtype Input
    associatedtype Output

    func callAsFunction(_ input: Input) throws -> Output
}

protocol ObjectURLMapper: Mapper {
    associatedtype O

    func callAsFunction(_ url: URL) throws -> O
}

enum FileBasedObjectLoadError: Error {
    case urlNotFound(FileURLProvider)
}

class MapProxy<L: Mapper, R: Mapper>: Mapper where L.Output == R.Input {
    let left: L
    let right: R

    init(left: L, right: R) {
        self.left = left
        self.right = right
    }

    func callAsFunction(_ input: L.Input) throws -> R.Output {
        return try right(try left(input))
    }
}

extension MapProxy: ObjectURLMapper where L.Input == URL {}

enum DataStringMapError: Error {
    case invalidData(Data)
}

final class DataStringMapper: Mapper {
    let encoding: String.Encoding

    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    } 

    func callAsFunction(_ input: Data) throws -> String  {
        guard let content = String(data: input, encoding: encoding) else { throw DataStringMapError.invalidData(input) }
        return content
    }
}

final class BundleURLProvider: FileURLProvider {
    let name: String
    let ext: String?

    init(name: String, ext: String?) {
        self.name = name
        self.ext = ext
    }

    convenience init(name: String) {
        let (name, ext) = name.nameAndExtension
        self.init(name: name, ext: ext)
    }

    func callAsFunction() -> URL? {
        return Bundle.module.url(forResource: name, withExtension: ext)
    }
}

private extension String {
    var nameAndExtension: (String, String?) {
        let components = split(separator: ".")
        return (String(components[0]), components.last.flatMap { String($0) })
    }
}

final class DataLoader: ObjectURLMapper {
    func callAsFunction(_ url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}

final class FileBasedObjectMaper<O, DataMapper: Mapper>
: MapProxy<DataLoader, DataMapper>
where DataMapper.Input == Data {}

class FileBasedObjectLoad<O, Mapper: ObjectURLMapper>: ObjectLoad where O == Mapper.O {
    let url: FileURLProvider
    let map: Mapper

    init(url: FileURLProvider, map: Mapper) {
        self.url = url
        self.map = map
    }

    func callAsFunction() throws -> O {
        guard let url = url() else { throw FileBasedObjectLoadError.urlNotFound(url) }
        return try map(url)
    }
}

extension URL: FileURLProvider {
    func callAsFunction() -> URL? {
        return self
    }
}
