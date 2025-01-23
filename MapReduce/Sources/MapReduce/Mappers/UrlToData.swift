import Foundation

public final class UrlToData: FailingMapper {
    public init() {}

    public func map(_ val: URL) -> Result<Data, Error> {
        return Result { try Data(contentsOf: val) }
    }
}
