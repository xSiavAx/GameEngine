extension GLBufferName {
    struct BoundParams<T: GLType> {
        var shouldNormilize: Bool
        var elementsCount: Int

        var elementType: T.Type { T.self }
    }
}