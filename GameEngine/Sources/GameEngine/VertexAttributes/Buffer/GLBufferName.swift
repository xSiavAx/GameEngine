import C_GL
import C_GLAD

struct GLBufferName: GLObjectName {
    let id: UInt32
    let type: BufferType

    func add<T: GLType>(
        _ data: [T],
        usage: GLBufferDataUsage = .staticDraw
    ) {
        data.withUnsafeBufferPointer { buffer in
            c_glBufferData(type.gl, GLsizeiptr(T.size * data.count), buffer.baseAddress, usage.gl)
        }
    }

    func add<V: AttributedVertex>(
        vertices: [V],
        usage: GLBufferDataUsage = .staticDraw
    ) {
        VertexPacker.withPacked(vertices: vertices) { address, size in
            c_glBufferData(type.gl, GLsizeiptr(size), address, usage.gl)
        }
    }
}

final class GLBufferNames: GLObjectNames<GLBufferName> {
    init(types: [BufferType], unbindAutomatically: Bool = true) {
        super.init(
            count: types.count,
            makeName: { idx, name in GLBufferName(id: name, type: types[idx]) },
            generate: { c_glGenBuffers($0, $1) },
            delete: { c_glDeleteBuffers($0, $1) }
        )
    }
}
