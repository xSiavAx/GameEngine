import C_GL
import C_GLAD

final class VertexBufferObject {
    private var names: VertexBufferNames

    init(types: [UInt32] = [C_GL_ARRAY_BUFFER]) {
        self.names = VertexBufferNames(types: types)
    }

    func bind(_ onBind: (_ idx: Int, _ name: VertexBufferName) -> Void) {
        names.names.enumerated().forEach { idx, name in
            c_glBindBuffer(name.type, name.id)

            onBind(idx, name)
        }
    }
}

struct VertexBufferName: VertexObjectName {
    struct BoundParams {
        var componentType: UInt32
        var sizeOfComponent: Int
        var shouldNormilize: UInt8
    }
    let id: UInt32
    let type: UInt32

    func add<T>(
        _ data: [T], 
        normalized: Bool,
        usage: UInt32 = C_GL_STATIC_DRAW
    ) -> BoundParams {
        let boundParams = BoundParams(
            componentType: C_GL_FLOAT,
            sizeOfComponent: MemoryLayout<T>.size,
            shouldNormilize: normalized ? C_GL_FALSE : C_GL_TRUE
        )
        data.withUnsafeBufferPointer { buffer in
            c_glBufferData(type, Int64(boundParams.sizeOfComponent * data.count), buffer.baseAddress, usage);
        }
        return boundParams
    }
}

final class VertexBufferNames: VertexObjectNames<VertexBufferName> {
    init(types: [UInt32]) {
        super.init(
            count: types.count,
            makeName: { idx, name in VertexBufferName(id: name, type: types[idx]) },
            generate: { c_glGenBuffers($0, $1) },
            delete: { c_glDeleteBuffers($0, $1) }
        )
    }
}
