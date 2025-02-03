import C_GLFW
import OpenCombineShim

final class InputProcessor: Sendable {
    let buttons = Buttons()

    func process(windowPtr: OpaquePointer) {
        buttons.process(windowPtr: windowPtr)
    }
}
