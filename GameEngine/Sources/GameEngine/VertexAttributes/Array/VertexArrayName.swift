import C_GL
import C_GLAD

enum VertexArrayError: Error {
    case noDrawerSet
}

final class VertexArrayName: VertexObjectName {
    let id: UInt32
    var drawer: VertexArrayDrawer?

    init(id: UInt32) {
        self.id = id
    }

    func linkVertexAttributes<T: GLType>(
        boundParams: GLBufferName.BoundParams<T>,
        location: Int,
        numberOfComponents: Int,
        offset: UnsafeRawPointer? = nil
    ) {
        c_glVertexAttribPointer(
            UInt32(location), // location for pos (sepcified in VertexShader.gs)
            Int32(numberOfComponents),
            T.glVal,
            boundParams.shouldNormilize,
            Int32(numberOfComponents * T.size), // size of vertext (all components)
            offset // offset in buffer (void *)
        )
    }

    func enableAttribute(location: Int) {
        c_glEnableVertexAttribArray(UInt32(location));
    }

    func withDebugDraw(_ onDraw: () -> Void) {
        c_glPolygonMode(C_GL_FRONT_AND_BACK, C_GL_LINE)
        defer { c_glPolygonMode(C_GL_FRONT_AND_BACK, C_GL_FILL) }
        onDraw()
    }

    func setDrawer(_ drawer: VertexArrayDrawer) {
        self.drawer = drawer
    }

    func draw() throws {
        guard let drawer else { throw VertexArrayError.noDrawerSet }
        drawer.draw()
    }
}

final class VertexArrayNames: GLObjectNames<VertexArrayName> {
    init(count: Int) {
        super.init(
            count: count,
            makeName: { idx, name in VertexArrayName(id: name) },
            generate: { c_glGenVertexArrays($0, $1) },
            delete: { c_glDeleteVertexArrays($0, $1) }
        )
    }
}

