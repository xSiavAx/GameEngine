import C_GLFW
import OpenCombineShim

extension InputProcessor {
    final class Mouse {
        let windowPtr: OpaquePointer
        var mode = Mode.normal
        nonisolated(unsafe) private var posObservers = [WeakWrapper<PosObserver>]()

        init(windowPtr: OpaquePointer) {
            self.windowPtr = windowPtr
        }

        func set(window: OpaquePointer, mode: Mode) {
            mode.apply(window: window)
        }

        func observeCursor(_ onChange: @escaping (_ x: Double, _ y: Double) -> Void) -> AnyCancellable {
            let observer = PosObserver(onChange: onChange)

            add(posObserver: observer)

            return observer.setOnCancel { [weak self, weak observer] in 
                guard let self, let observer else { return }
                remove(posObserver: observer) 
            }
        }

        private func add(posObserver: PosObserver) {
            posObservers.append(WeakWrapper(wrappe: posObserver))
            if posObservers.count == 1 {
                // Subscribe
            }
        }

        private func remove(posObserver: PosObserver) {
            posObservers.removeAll { $0.wrappe === posObserver }
            if posObservers.count == 0 {
                // Unsubscribe
            }
        }
    }
}

extension InputProcessor.Mouse {
    struct Mode: GLConstantRepresentable {
        let gl: Int32

        static let normal = m(GLFW_CURSOR_NORMAL)
        static let hidden = m(GLFW_CURSOR_HIDDEN)
        static let disabled = m(GLFW_CURSOR_DISABLED)

        func apply(window: OpaquePointer) {
            InputProcessor.Mode.cursor.apply(window: window, val: gl)
        }
    }
}
