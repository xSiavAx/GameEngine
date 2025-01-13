extension InputProcessor {
    final class Observer: ClosureReleasable {
        let key: Key 
        let event: KeyEvent
        var handler: (() -> Void)?

        init(key: Key, event: KeyEvent) {
            self.key = key
            self.event = event
            super.init()
        }

        func fire(event: KeyEvent) {
            if self.event == event {
                handler?()
            }
        }
    }
}
