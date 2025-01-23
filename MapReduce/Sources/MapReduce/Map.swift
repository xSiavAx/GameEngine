public extension Result {
    func erase() -> Result<Success, Error> {
        return Result<Success, Error> { try get() }
    }
}

public protocol Mapper {
    associatedtype Input
    associatedtype Output

    func map(_ input: Input) -> Output
}

public protocol FailingMapper {
    associatedtype Input
    associatedtype Output
    associatedtype OutputError: Error

    func map(_ input: Input) -> Result<Output, OutputError>
}

extension FailingMapper {
    public func erase() -> AnyFailingMapper<Input, Output, Error> {
        return AnyFailingMapper { map($0).erase() }
    }
}

public final class AnyMapper<Input, Output>: Mapper {
    private let onMap: (Input) -> Output

    public init(onMap: @escaping (Input) -> Output) {
        self.onMap = onMap
    }

    public func map(_ val: Input) -> Output {
        return onMap(val)
    }
}

public final class AnyFailingMapper<Input, Output, OutputError: Error>: FailingMapper {
    private let onMap: (Input) -> Result<Output, OutputError>

    public init(onMap: @escaping (Input) -> Result<Output, OutputError>) {
        self.onMap = onMap
    }

    public func map(_ val: Input) -> Result<Output, OutputError> {
        return onMap(val)
    }
}

extension Mapper {
    public func map<Other: Mapper>(_ other: Other) -> AnyMapper<Input, Other.Output> where Output == Other.Input {
        return AnyMapper { other.map(map($0)) }
    }

    public func map<Other: FailingMapper>(
        _ other: Other
    ) -> AnyFailingMapper<Input, Other.Output, Other.OutputError> where Output == Other.Input {
        return AnyFailingMapper { other.map(map($0)) }
    }
}

extension FailingMapper {
    public func map<Other: Mapper>(other: Other) -> AnyFailingMapper<Input, Other.Output, OutputError> where Output == Other.Input {
        return AnyFailingMapper { map($0).map(other.map) }
    }

    public func map<Other: FailingMapper>(
        other: Other
    ) -> AnyFailingMapper<Input, Other.Output, OutputError> where Output == Other.Input, OutputError == Other.OutputError {
        return AnyFailingMapper { map($0).flatMap(other.map) }
    }
}
