import OpenCombineShim
import C_GLFW

extension InputProcessor {
    final class Mouse {
        let windowPtr: OpaquePointer
        let cursorPosition: PositionUpdatesCenter
        let scroll: PositionUpdatesCenter

        init(windowPtr: OpaquePointer) {
            self.windowPtr = windowPtr
            self.cursorPosition = PositionUpdatesCenter(
                subscribe: { glfwSetCursorPosCallback(windowPtr, cursopr_pos_callback) },
                unsubscribe: { glfwSetCursorPosCallback(windowPtr, nil) }
            )
            self.scroll = PositionUpdatesCenter(
                subscribe: { glfwSetScrollCallback(windowPtr, scroll_callback) },
                unsubscribe: { glfwSetScrollCallback(windowPtr, nil) }
            )
        }

        func set(mode: Mode) {
            mode.apply(window: windowPtr)
        }

        fileprivate func handleMousePos(x: Double, y: Double) {
            cursorPosition.notify(x: x, y: y)
        }

        fileprivate func handleScroll(x: Double, y: Double) {
            scroll.notify(x: x, y: y)
        }
    }
}

extension InputProcessor.Mouse {
    final class PositionUpdatesCenter {
        private var observers = [PositionObserver]()
        var subscribe: () -> Void
        var unsubscribe: () -> Void

        init(subscribe: @escaping () -> Void, unsubscribe: @escaping () -> Void) {
            self.subscribe = subscribe
            self.unsubscribe = unsubscribe
        }

        func observe(_ onChange: @escaping (_ x: Double, _ y: Double) -> Void) -> AnyCancellable {
            let observer = PositionObserver(onChange: onChange)

            add(observer: observer)

            return observer.setOnCancel { [weak self, weak observer] in 
                guard let self, let observer else { return }
                remove(observer: observer) 
            }
        }

        private func add(observer: PositionObserver) {
            observers.append(observer)
            if observers.count == 1 {
                subscribe()
            }
        }

        private func remove(observer: PositionObserver) {
            observers.removeAll { $0 === observer }
            if observers.isEmpty {
                unsubscribe()
            }
        }

        fileprivate func notify(x: Double, y: Double) {
            observers.forEach { $0.fire(x: x, y: y) }
        }
    }
}

private func cursopr_pos_callback(window: OpaquePointer?, x: Double, y: Double) {
    guard let window, let window = WindowsManager.shared.get(key: window) else { return }
    window.inputProcessor.mouse.handleMousePos(x: x, y: y)
}

private func scroll_callback(window: OpaquePointer?, x: Double, y: Double) {
    guard let window, let window = WindowsManager.shared.get(key: window) else { return }
    window.inputProcessor.mouse.handleScroll(x: x, y: y)
}
