@preconcurrency import OpenCombineShim

extension InputProcessor {
    final class Observer: Cancellable {
        let key: Key 
        let event: KeyEvent
        var handler: () -> Void

        init(key: Key, event: KeyEvent, handler: () -> Void) {
            self.key = key
            self.event = event
            self.handler = handler
            super.init()
        }

        func setOnCancel(_ onCancel: @escaping () -> Void) -> AnyCancellable {
            token = AnyCancellable {
                onCancel()
            }
        }

        func fire(event: KeyEvent) {
            if token != nil, self.event == event {
                handler?()
            }
        }
    }
}
