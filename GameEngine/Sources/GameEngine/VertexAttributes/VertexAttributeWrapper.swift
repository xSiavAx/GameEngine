@propertyWrapper 
struct VertexAttributeWrapper<T: PackingVertexAtttribute & VertexAttributeType>: PackingBoundVertexAtttribute {
    var wrappedValue: T
    let shouldNormilize: Bool
    let attribute: VertexAttribute<T>

    var projectedValue: PackingBoundVertexAtttribute { self }

    var bound: BoundVertexAttribute { T.makeBound(shouldNormilize: shouldNormilize, location: attribute.location) }
    var value: PackingVertexAtttribute { wrappedValue }
}

extension VertexAttributeWrapper: Sendable where T: Sendable {}

@propertyWrapper 
struct CustomVertexAttributeWrapper<T: VertexAtttributeRepresentable>: PackingBoundVertexAtttribute {
    var wrappedValue: T
    let shouldNormilize: Bool
    let attribute: VertexAttribute<T.T>

    var projectedValue: PackingBoundVertexAtttribute { self }

    var bound: BoundVertexAttribute { T.T.makeBound(shouldNormilize: shouldNormilize, location: attribute.location) }
    var value: PackingVertexAtttribute { wrappedValue.asVertexAttribute }
}

extension CustomVertexAttributeWrapper: Sendable where T: Sendable {}