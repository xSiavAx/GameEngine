import C_GL
import C_GLFW

protocol WindowContext: AnyObject {
    func didMakeCurrent(window: Window)
    func ensureGLReady() throws
    func windowDidChangeSize(_ window: Window)
}

final class Window {
    private let ptr: OpaquePointer
    unowned let context: WindowContext
    private(set) var size: ISize

    init?(size: ISize, title: String, context: WindowContext) {
        guard let ptr: OpaquePointer = glfwCreateWindow(size.cWidth, size.cHeight, title, nil, nil) else {
            return nil
        }
        self.ptr = ptr
        self.context = context
        self.size = size
        WindowsManager.shared.add(key: ptr, window: self)
    }

    deinit {
        WindowsManager.shared.remove(key: ptr)
    }

    func shouldClose() -> Bool {
        return glfwWindowShouldClose(ptr) != 0
    }

    func swapBuffers() {
        glfwSwapBuffers(ptr)
    }

    func makeContextCurrent() {
        glfwMakeContextCurrent(ptr)
        context.didMakeCurrent(window: self)
    }

    func setupResizeHandler() throws {
        try context.ensureGLReady()
        glfwSetFramebufferSizeCallback(ptr, windowSizeDidChange)
    }

    func didChange(size: ISize) {
        self.size = size
        context.windowDidChangeSize(self)
    }

    func processInput(_ processor: InputProcessor) {
        processor.process(windowPtr: ptr)
    }

    func requestClose() {
        glfwSetWindowShouldClose(ptr, 1)
    }
}

private func windowSizeDidChange(ptr: OpaquePointer?, width: Int32, height: Int32) {
    guard let ptr else { return }
    WindowsManager.shared.get(key: ptr)?.didChange(size: ISize(width: width, height: height))
}
