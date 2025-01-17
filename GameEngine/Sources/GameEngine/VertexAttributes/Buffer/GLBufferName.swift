import C_GL
import C_GLAD

struct GLBufferName: VertexObjectName {
    struct BoundParams<T: GLType> {
        var shouldNormilize: UInt8
        var elementsCount: Int

        var elementType: T.Type { T.self }
    }
    let id: UInt32
    let type: UInt32

    func add<T: GLType>(
        _ data: [T],
        normalized: Bool = true,
        usage: UInt32 = C_GL_STATIC_DRAW
    ) -> BoundParams<T> {
        data.withUnsafeBufferPointer { buffer in
            c_glBufferData(type, Int64(T.size * data.count), buffer.baseAddress, usage);
        }

        return BoundParams<T>(
            shouldNormilize: normalized ? C_GL_FALSE : C_GL_TRUE,
            elementsCount: data.count
        )
    }
}

final class GLBufferNames: GLObjectNames<GLBufferName> {
    init(types: [UInt32]) {
        super.init(
            count: types.count,
            makeName: { idx, name in GLBufferName(id: name, type: types[idx]) },
            generate: { c_glGenBuffers($0, $1) },
            delete: { c_glDeleteBuffers($0, $1) }
        )
    }
}
