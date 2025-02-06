import C_GLFW

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
