extension GLBufferName {
    struct BoundParams<T: GLType> {
        var shouldNormilize: UInt8
        var elementsCount: Int

        var elementType: T.Type { T.self }
    }
}