import Foundation

public protocol DataProducer {
    associatedtype S
    associatedtype F: Error

    func produce() -> Result<S, F>
}

extension DataProducer {
    public func get() throws-> S { return try produce().get() }
}

public final class AnyProducer<S, F: Error>: DataProducer {
    private let onProduce: () -> Result<S, F>

    public init(_ onProduce: @escaping () -> Result<S, F>) {
        self.onProduce = onProduce
    }

    public func produce() -> Result<S, F> {
        onProduce()
    }
}

extension DataProducer {
    public func map<Map: Mapper>(_ mapper: Map) -> AnyProducer<Map.Output, F> where Map.Input == S {
        return AnyProducer { produce().map(mapper.map) }
    }

    public func mapError<Map: Mapper>(_ mapper: Map) -> AnyProducer<S, Map.Output> where Map.Input == F, Map.Output: Error {
        return AnyProducer { produce().mapError(mapper.map) }
    }

    public func flatMap<Map: FailingMapper>(_ mapper: Map) -> AnyProducer<Map.Output, F> where Map.Input == S, Map.OutputError == F {
        return AnyProducer { produce().flatMap(mapper.map) }
    }

    public func flatMapError<Map: FailingMapper>(_ mapper: Map) -> AnyProducer<S, Map.OutputError> where Map.Input == F, Map.Output == S {
        return AnyProducer { produce().flatMapError(mapper.map) }
    }
}

extension DataProducer where F == Never {
    public func map<Map: FailingMapper>(
        _ mapper: Map
    ) -> AnyProducer<Map.Output, Map.OutputError> where Map.Input == S {
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
