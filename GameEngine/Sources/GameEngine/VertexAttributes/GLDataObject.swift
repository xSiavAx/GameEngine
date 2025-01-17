class GLDataObject<Name: VertexObjectName, Names: GLObjectNames<Name>> {
    var names: Names
    var bind: (Name) -> Void

    init(names: Names, bind: @escaping (Name) -> Void) {
        self.names = names
        self.bind = bind
    }

    func bind(onBind: (Int, Name) throws -> Void) rethrows {
        try names.names.enumerated().forEach { idx, name in
            bind(name)
            try onBind(idx, name)
        }
    }
}


final class GLDataSingle<Name: VertexObjectName, Names: GLObjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) throws -> Void) rethrows {
        try bind { idx, name in
            try super.bind { _, name in try onBind(name) }
        }
    }
}
