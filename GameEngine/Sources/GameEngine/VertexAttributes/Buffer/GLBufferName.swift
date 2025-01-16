import C_GL
import C_GLAD

struct GLBufferName: VertexObjectName {
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
        let componentSize = add(data, usage: usage)

        return BoundParams(
            componentType: C_GL_FLOAT,
            sizeOfComponent: componentSize,
            shouldNormilize: normalized ? C_GL_FALSE : C_GL_TRUE
        )
    }
    
    @discardableResult
    func add<T>(
        _ data: [T], 
        usage: UInt32 = C_GL_STATIC_DRAW
    ) -> Int {
        let componentSize = MemoryLayout<T>.size

        data.withUnsafeBufferPointer { buffer in
            c_glBufferData(type, Int64(componentSize * data.count), buffer.baseAddress, usage);
        }
        return MemoryLayout<T>.size
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
