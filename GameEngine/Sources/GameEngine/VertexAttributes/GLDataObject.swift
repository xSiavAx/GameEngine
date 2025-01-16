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


final class GLDataSingle<Name: VertexObjectName, Names: GLOBjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) -> Void) {
        names.names.enumerated().forEach { idx, name in
            super.bind { _, name in onBind(name) }
        }
    }
}
