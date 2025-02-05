import OpenCombineShim
import C_GLFW

extension InputProcessor {
    final class Mouse {
        let windowPtr: OpaquePointer
        nonisolated(unsafe) private var posObservers = [PosObserver]()

        init(windowPtr: OpaquePointer) {
            self.windowPtr = windowPtr
        }

        func set(mode: Mode) {
            mode.apply(window: windowPtr)
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
            posObservers.append(posObserver)
            if posObservers.count == 1 {
                glfwSetCursorPosCallback(windowPtr, cursopr_pos_callback)
            }
        }

        private func remove(posObserver: PosObserver) {
            posObservers.removeAll { $0 === posObserver }
            if posObservers.isEmpty {
                glfwSetCursorPosCallback(windowPtr, nil)
            }
        }

        fileprivate func handleMousePos(x: Double, y: Double) {
            posObservers
                .forEach {
                    $0.fire(x: x, y: y)
                }
        }
    }
}

private func cursopr_pos_callback(window: OpaquePointer?, x: Double, y: Double) {
    guard let window, let window = WindowsManager.shared.get(key: window) else { return }
    window.inputProcessor.mouse.handleMousePos(x: x, y: y)
}
