import C_GL
import C_GLAD

final class VertexArrayObject {
    private var names: VertexArrayNames

    init(count: Int = 1) {
        names = VertexArrayNames(count: count)
    }

    func bind(onBind: (Int) -> Void) {
        names.names.enumerated().forEach { idx, name in
            c_glBindVertexArray(name.id)
            onBind(idx)
        }
    }

    func bind() {
        bind { _ in }
    }


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

    func enable(location: Int) {
        c_glEnableVertexAttribArray(UInt32(location));
    }
}

struct VertexArrayName: VertexObjectName {
    let id: UInt32
}

final class VertexArrayNames: VertexObjectNames<VertexArrayName> {
    init(count: Int) {
        super.init(
            count: count,
            makeName: { idx, name in VertexArrayName(id: name) },
            generate: { c_glGenVertexArrays($0, $1) },
            delete: { c_glDeleteVertexArrays($0, $1) }
        )
    }
}

