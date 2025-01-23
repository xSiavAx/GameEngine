import Foundation

public enum DataStringMapError: Error {
    case invalidData(Data)
}

public final class DataToString: FailingMapper {
    public let encoding: String.Encoding

    public init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    } 

    public func map(_ val: Data) -> Result<String, DataStringMapError> {
        guard let content = String(data: val, encoding: encoding) else { 
            return .failure(DataStringMapError.invalidData(val))
        }
        return .success(content)
    }
}
