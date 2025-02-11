protocol PackingVertex {
    static var attributes: [KeyPath<Self, any PackingBoundVertexAtttribute>] { get }
}
