import C_GL
import C_GLAD

struct VertexArrayName: VertexObjectName {
    let id: UInt32

    func linkVertexAttributes(
        boundParams: VertexBufferName.BoundParams,
        location: Int,
        numberOfComponents: Int,
        offset: UnsafeRawPointer? = nil
    ) {
        c_glVertexAttribPointer(
            UInt32(location), // location for pos (sepcified in VertexShader.gs)
            Int32(numberOfComponents),
            boundParams.componentType,
            boundParams.shouldNormilize,
            Int32(numberOfComponents * boundParams.sizeOfComponent), // size of vertext (all components)
            offset // offset in buffer (void *)
        );
    }

    func enableAttribute(location: Int) {
        c_glEnableVertexAttribArray(UInt32(location));
    }
}

final class VertexArrayNames: GLOBjectNames<VertexArrayName> {
    init(count: Int) {
        super.init(
            count: count,
            makeName: { idx, name in VertexArrayName(id: name) },
            generate: { c_glGenVertexArrays($0, $1) },
            delete: { c_glDeleteVertexArrays($0, $1) }
        )
    }
}

