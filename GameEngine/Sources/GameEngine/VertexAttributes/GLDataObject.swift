class GLDataObject<Name: GLObjectName, Names: GLObjectNames<Name>> {
    var names: Names
    var bind: (Name) -> Void
    var unbind: (Name) -> Void
    var unbindAutomatically: Bool

    init(names: Names, bind: @escaping (Name) -> Void, unbind: @escaping (Name) -> Void, unbindAutomatically: Bool) {
        self.names = names
        self.bind = bind
        self.unbind = unbind
        self.unbindAutomatically = unbindAutomatically
    }

    func bind(onBind: (Int, Name) throws -> Void) rethrows {
        guard let last = names.names.last else { return }
        try names.names.enumerated().forEach { idx, name in
            bind(name)
            try onBind(idx, name)
        }
        if unbindAutomatically {
            unbind(last)
        }
    }
}


final class GLDataSingle<Name: GLObjectName, Names: GLObjectNames<Name>>: GLDataObject<Name, Names> {
    func bind(onBind: (Name) throws -> Void) rethrows {
        try bind { idx, name in
            try super.bind { _, name in try onBind(name) }
        }
    }
}
