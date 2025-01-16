import C_GLAD

typealias VertexArrayObject = GLDataObject<VertexArrayName, VertexArrayNames>
typealias VertexArraySingle = GLDataSingle<VertexArrayName, VertexArrayNames>
typealias VertexBufferObject = GLDataObject<VertexBufferName, VertexBufferNames>
typealias VertexBufferSingle = GLDataSingle<VertexBufferName, VertexBufferNames>


class GLDataObject<Name: VertexObjectName, Names: GLOBjectNames<Name>> {
    var names: Names
    var bind: (Name) -> Void

    init(names: Names, bind: @escaping (Name) -> Void) {
        self.names = names
        self.bind = bind
    }

    func bind(onBind: (Int, Name) -> Void) {
        names.names.enumerated().forEach { idx, name in
            bind(name)
            onBind(idx, name)
        }
    }
}

extension GLDataObject where Names == VertexArrayNames, Name == VertexArrayName {
    convenience init(count: Int = 1) {
        self.init(names: VertexArrayNames(count: count)) {
            c_glBindVertexArray($0.id)
        }
    }
}

extension GLDataObject where Names == VertexBufferNames, Name == VertexBufferName {
    convenience init(types: [UInt32]) {
        self.init(names: VertexBufferNames(types: types)) {
            print("Bind type: \($0.type) name: \($0.id)")
            c_glBindBuffer($0.type, $0.id)
        }
    }
}

final class GLDataSingle<Name: VertexObjectName, Names: GLOBjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) -> Void) {
        names.names.enumerated().forEach { idx, name in
            super.bind { _, name in onBind(name) }
        }
    }
}

extension GLDataSingle where Names == VertexArrayNames, Name == VertexArrayName {
    func bind() {
        bind { _ in }
    }
}

extension GLDataSingle where Names == VertexBufferNames, Name == VertexBufferName {
    convenience init(type: UInt32) {
        self.init(types: [type])
    }
}
