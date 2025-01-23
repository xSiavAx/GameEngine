import Foundation
import MapReduce

struct ResourceReference {
    var title: String
    var ext: String?

    init(title: String, ext: String?) {
        self.title = title
        self.ext = ext
    }

    init(name: String) {
        let (title, ext) = name.nameAndExtension
        self.init(title: title, ext: ext)
    }
}

extension ResourceReference: SelfProducer {}

final class ResourceReferenceToOptionalUrl: Mapper {
    func map(_ val: ResourceReference) -> URL? {
        return Bundle.module.url(forResource: val.title, withExtension: val.ext)
    }
}

enum ResourceURLError: Error {
    case resoruceNotFound(ResourceReference)
}

final class ResourceReferenceToUrl: FailingMapper {
    func map(_ val: ResourceReference) -> Result<URL, ResourceURLError> {
        guard let url = ResourceReferenceToOptionalUrl().map(val) else {
            return .failure(ResourceURLError.resoruceNotFound(val))
        }
        return .success(url)
    }
}

private extension String {
    var nameAndExtension: (String, String?) {
        let components = split(separator: ".")
        let name = String(components[0])
        let ext = components.count > 1 ?  components.last.flatMap { String($0) } : nil

        return (name, ext)
    }
}
