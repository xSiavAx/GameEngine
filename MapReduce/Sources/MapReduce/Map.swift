public extension Result {
    func erase() -> Result<Success, Error> {
        return Result<Success, Error> { try get() }
    }
}

public protocol Mapper {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error

    func map(_ input: Input) -> Result<Output, Failure>
}

extension Mapper where Failure == Never {
    func map(_ input: Input) -> Output {
        switch map(input) {
            case .success(let val): return val
        }
    }
}

extension Mapper {
    public func erase() -> AnyMapper<Input, Output, Error> {
        return AnyMapper { map($0).erase() }
    }
}

public final class AnyMapper<Input, Output, Failure: Error>: Mapper {
    private let onMap: (Input) -> Result<Output, Failure>

    public init(onMap: @escaping (Input) -> Result<Output, Failure>) {
        self.onMap = onMap
    }

    public func map(_ val: Input) -> Result<Output, Failure> {
        return onMap(val)
    }
}

extension Mapper {
    public func map<Other: Mapper>(other: Other) -> AnyMapper<Input, Other.Output, Failure> where Output == Other.Input, Other.Failure == Never {
        return AnyMapper { map($0).map(other.map) }
    }

    public func map<Other: Mapper>(
        other: Other
    ) -> AnyMapper<Input, Other.Output, Failure> where Output == Other.Input, Failure == Other.Failure {
        return AnyMapper { map($0).flatMap(other.map) }
    }
}
