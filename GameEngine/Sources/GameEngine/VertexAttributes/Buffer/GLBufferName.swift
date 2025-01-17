import C_GL
import C_GLAD

struct GLBufferName: VertexObjectName {
    let id: UInt32
    let type: BufferType

    func add<T: GLType>(
        _ data: [T],
        normalized: Bool = true,
        usage: UInt32 = C_GL_STATIC_DRAW
    ) -> BoundParams<T> {
        data.withUnsafeBufferPointer { buffer in
            c_glBufferData(type.gl, Int64(T.size * data.count), buffer.baseAddress, usage);
        }

        return BoundParams<T>(
            shouldNormilize: normalized ? C_GL_FALSE : C_GL_TRUE,
            elementsCount: data.count
        )
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
}

final class GLBufferNames: GLObjectNames<GLBufferName> {
    init(types: [BufferType]) {
        super.init(
            count: types.count,
            makeName: { idx, name in GLBufferName(id: name, type: types[idx]) },
            generate: { c_glGenBuffers($0, $1) },
            delete: { c_glDeleteBuffers($0, $1) }
        )
    }
}
