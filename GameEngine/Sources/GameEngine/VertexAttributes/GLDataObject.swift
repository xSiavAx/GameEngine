import C_GLAD

typealias VertexArrayObject = GLDataObject<VertexArrayName, VertexArrayNames>
typealias VertexArraySingle = GLDataSingle<VertexArrayName, VertexArrayNames>

class GLDataObject<Name: VertexObjectName, Names: VertexObjectNames<Name>> {
    var names: Names
    var bind: (UInt32) -> Void

    init(names: Names, bind: @escaping (UInt32) -> Void) {
        self.names = names
        self.bind = bind
    }

    func bind(onBind: (Int, Name) -> Void) {
        names.names.enumerated().forEach { idx, name in
            bind(name.id)
            onBind(idx, name)
        }
    }
}

final class GLDataSingle<Name: VertexObjectName, Names: VertexObjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) -> Void) {
        names.names.enumerated().forEach { idx, name in
            super.bind { _, name in onBind(name) }
        }
    }
}

extension GLDataObject where Names == VertexArrayNames, Name == VertexArrayName {
    convenience init(count: Int = 1) {
        self.init(names: VertexArrayNames(count: count), bind: c_glBindVertexArray)
    }
}

extension GLDataSingle where Names == VertexArrayNames, Name == VertexArrayName {
    func bind() {
        bind { _ in }
    }
}