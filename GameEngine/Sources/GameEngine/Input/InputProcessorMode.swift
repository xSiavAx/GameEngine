import C_GLFW

extension InputProcessor {
    struct Mode: GLConstantRepresentable {
        let gl: Int32

        static let cursor = m(GLFW_CURSOR)
        static let stickyKeys = m(GLFW_STICKY_KEYS)
        static let stickyMouseButtons = m(GLFW_STICKY_MOUSE_BUTTONS)
        static let lockKeyMods = m(GLFW_LOCK_KEY_MODS)
        static let rawMouseMotion = m(GLFW_RAW_MOUSE_MOTION)

        func apply(window: OpaquePointer, val: Int32) {
            glfwSetInputMode(window, gl, val)
        }
    }
}
