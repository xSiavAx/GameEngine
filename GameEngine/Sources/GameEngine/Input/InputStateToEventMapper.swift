extension InputProcessor {
    struct StateToEventMapper {
        private(set) var oldDownKeys: Set<Key>
        private(set) var downKeys = Set<Key>()

        init(downKeys: Set<Key>) {
            oldDownKeys = downKeys
        }

        mutating func map(key: Key, state: KeyState) -> KeyEvent? {
            switch state {
                case .press:
                    downKeys.insert(key)

                    if oldDownKeys.contains(key) {
                        return .keyHold
                    }
                    return .keyDown
                case .release:
                    if oldDownKeys.contains(key) {
                        return .keyUp
                    }
                    return nil
                case .hold:
                    return nil
            }
        }
    }
}
