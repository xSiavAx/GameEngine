import C_GLFW
import OpenCombineShim

final class InputProcessor {
    let buttons: Buttons
    let mouse: Mouse

    init(windowPtr: OpaquePointer) {
        self.buttons = Buttons(windowPtr: windowPtr)
        self.mouse = Mouse(windowPtr: windowPtr)
    }

    func process() {
        buttons.process()
    }
}
