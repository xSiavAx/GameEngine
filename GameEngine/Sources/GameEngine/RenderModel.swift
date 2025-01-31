protocol RenderModel {
    var transform: Transform { get }
}

struct AnyModel: RenderModel {
    var transform: Transform
}
