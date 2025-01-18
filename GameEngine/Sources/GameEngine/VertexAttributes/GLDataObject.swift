class GLDataObject<Name: GLObjectName, Names: GLObjectNames<Name>> {
    var names: Names
    var bind: (Name) -> Void
    var unbind: (Name) -> Void

    init(names: Names, bind: @escaping (Name) -> Void, unbind: @escaping (Name) -> Void) {
        self.names = names
        self.bind = bind
        self.unbind = unbind
    }

    func bind(onBind: (Int, Name) throws -> Void) rethrows {
        guard let last = names.names.last else { return }
        try names.names.enumerated().forEach { idx, name in
            bind(name)
            try onBind(idx, name)
        }
        unbind(last)
    }
}


final class GLDataSingle<Name: GLObjectName, Names: GLObjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) throws -> Void) rethrows {
        try bind { idx, name in
            try super.bind { _, name in try onBind(name) }
        }
    }
}
