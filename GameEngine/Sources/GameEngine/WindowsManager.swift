
final class WindowsManager {
    nonisolated(unsafe) static let shared = WindowsManager()

    private var windows = [OpaquePointer : WeakWrapper<Window>]()

    func add(key: OpaquePointer, window: Window) {
        windows[key] = WeakWrapper(wrappe: window)
    }

    func remove(key: OpaquePointer) {
        windows[key] = nil
    }

    func get(key: OpaquePointer) -> Window? {
        return windows[key]?.wrappe
    }
}