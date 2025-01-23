import Foundation

public protocol DataProducer {
    associatedtype Success
    associatedtype Failure: Error

    func produce() -> Result<Success, Failure>
}

extension DataProducer {
    public func get() throws-> Success { return try produce().get() }
}

public final class AnyProducer<Success, Failure: Error>: DataProducer {
    private let onProduce: () -> Result<Success, Failure>

    public init(_ onProduce: @escaping () -> Result<Success, Failure>) {
        self.onProduce = onProduce
    }

    public func produce() -> Result<Success, Failure> {
        onProduce()
    }
}

extension DataProducer {
    public func map<Map: Mapper>(_ mapper: Map) -> AnyProducer<Map.Output, Failure> where Map.Input == Success, Map.Failure == Never {
        return AnyProducer { produce().map(mapper.map) }
    }

    public func mapError<Map: Mapper>(_ mapper: Map) -> AnyProducer<Success, Map.Output> where Map.Input == Failure, Map.Output: Error, Map.Failure == Never {
        return AnyProducer { produce().mapError(mapper.map) }
    }

    public func flatMap<Map: Mapper>(_ mapper: Map) -> AnyProducer<Map.Output, Failure> where Map.Input == Success, Map.Failure == Failure {
        return AnyProducer { produce().flatMap(mapper.map) }
    }

    public func flatMapError<Map: Mapper>(_ mapper: Map) -> AnyProducer<Success, Map.Failure> where Map.Input == Failure, Map.Output == Success {
        return AnyProducer { produce().flatMapError(mapper.map) }
    }
}

extension DataProducer where Failure == Never {
    public func map<Map: Mapper>(
        _ mapper: Map
    ) -> AnyProducer<Map.Output, Map.Failure> where Map.Input == Success {
        return AnyProducer { 
            switch produce() {
                case .success(let val): mapper.map(val)
                case .failure: fatalError()
            }
        }
    }
}

public protocol SelfProducer: DataProducer {}

extension SelfProducer {
    public func produce() -> Result<Self, Never> { .success(self) }
}

extension Bool: SelfProducer {}
extension String: SelfProducer {}
extension Int: SelfProducer {}
extension URL: SelfProducer {}
