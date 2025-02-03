import C_GLFW
import OpenCombineShim

extension InputProcessor {
    final class Buttons {
        let windowPtr: OpaquePointer

        private var observers = [Key : [Observer]]()
        private var downKeys = Set<Key>()

        init(windowPtr: OpaquePointer) {
            self.windowPtr = windowPtr
        }

        func process() {
            var mapper = StateToEventMapper(downKeys: downKeys)

            observers.forEach { key, keyObservers in
                if let state = state(for: key, using: windowPtr), let event = mapper.map(key: key, state: state) {
                    keyObservers.forEach {
                        $0.fire(event: event)
                    }
                }
            }
            downKeys = mapper.downKeys
        }

        func addObserver(key: Key, event: KeyEvent, onEvent: @escaping () -> Void) -> AnyCancellable {
            let observer = Observer(key: key, event: event, handler: onEvent)

            let token = observer.setOnCancel { [weak self, weak observer] in 
                guard let self, let observer else { return }
                remove(observer: observer) 
            }
            observers[key, default: []].append(observer)
            return token
        }

        private func remove(observer: Observer) {
            let key = observer.key

            guard var list = observers[observer.key] else { return }
            if let index = list.firstIndex(where: { $0 === observer }) {
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
}
