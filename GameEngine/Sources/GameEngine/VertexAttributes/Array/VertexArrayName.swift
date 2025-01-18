import C_GL
import C_GLAD

enum VertexArrayError: Error {
    case noDrawerSet
}

final class VertexArrayName: GLObjectName {
    let id: UInt32
    var drawer: VertexArrayDrawer?

    init(id: UInt32) {
        self.id = id
    }

    func enableAttribute(location: Int) {
        c_glEnableVertexAttribArray(UInt32(location));
    }

    func withDebugDraw(_ onDraw: () -> Void) {
        c_glPolygonMode(GLFace.frontAndBack.gl, GLPolygonMode.line.gl)
        defer { c_glPolygonMode(GLFace.frontAndBack.gl, GLPolygonMode.fill.gl) }
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

