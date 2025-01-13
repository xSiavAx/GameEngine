import C_GLFW

final class InputProcessor: Sendable {
    nonisolated(unsafe) private var observers = [Key : [WeakWrapper<Observer>]]()
    nonisolated(unsafe) private var downKeys = Set<Key>()

    func process(windowPtr: OpaquePointer) {
        var mapper = StateToEventMapper(downKeys: downKeys)

        observers.forEach { key, keyObservers in
            if let state = state(for: key, using: windowPtr), let event = mapper.map(key: key, state: state) {
                keyObservers.compactMap(\.wrappe).forEach {
                    $0.fire(event: event)
                }
            }
        }
        downKeys = mapper.downKeys
    }

    func addObserver(key: Key, event: KeyEvent, onEvent: @escaping () -> Void) -> Releasable {
        let observer = Observer(key: key, event: event)

        observer.onRelease = { [weak self, weak observer] in 
            guard let self, let observer else { return }
            remove(observer: observer) 
        }
        observer.handler = onEvent

        observers[key, default: []].append(WeakWrapper(wrappe: observer))
        return observer
    }

    private func remove(observer: Observer) {
        let key = observer.key

        guard var list = observers[observer.key] else { return }
        if let index = list.firstIndex(where: { $0.wrappe === observer }) {
            list.remove(at: index)
            observers[key] = list.isEmpty ? nil : list
        }
    }

    private func state(for key: Key, using windowPtr: OpaquePointer) -> KeyState? {
        switch glfwGetKey(windowPtr, key.rawValue) {
        case GLFW_RELEASE: return .release
        case GLFW_PRESS: return .press
        case GLFW_REPEAT: return .hold
        default: return nil
        }
    }
}
