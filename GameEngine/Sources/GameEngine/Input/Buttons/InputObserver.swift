@preconcurrency import OpenCombineShim

extension InputProcessor {
    final class Observer {
        let key: Key 
        let event: KeyEvent
        var handler: () -> Void

        init(key: Key, event: KeyEvent, handler: @escaping () -> Void) {
            self.key = key
            self.event = event
            self.handler = handler
        }

        func setOnCancel(_ onCancel: @escaping () -> Void) -> AnyCancellable {
            return AnyCancellable {
                onCancel()
            }
        }

        func fire(event: KeyEvent) {
            if self.event == event {
                handler()
            }
        }
    }
}
