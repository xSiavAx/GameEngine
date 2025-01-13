import C_GL
import C_GLFW

enum ContextError: Error {
    case initializatioError
    case windowCreationError
    case glVersionDidNotSet
    case currentWindowDidNotSet
    case gladDidNotLoad
}

final class Context {
    private(set) var currentWindow: Window?
    private(set) var glVersionDidConfigure = false
    private(set) var gladDidLoad = false
    var currentWindowDidSet: Bool { currentWindow != nil }

    let inputProcessor = InputProcessor()

    private(set) var viewPortSize: ISize = .zero {
        didSet { viewPortSizeDidSet() }
    }

    init() throws {
        if glfwInit() != GLFW_TRUE {
            throw ContextError.initializatioError
        }
    }

    static func make(glVersion: (major: Int, minor: Int)) throws -> Context {
        let context = try Context()

        context.set(glVersion: glVersion)

        return context
    }

    func set(glVersion: (major: Int, minor: Int)) {
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, Int32(glVersion.major));
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, Int32(glVersion.minor));
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glVersionDidConfigure = true
    }

    func pollEvents() {
        glfwPollEvents()
    }

    func makeWindow(size: ISize, title: String) throws -> Window {
        guard let window = Window(size: size, title: title, context: self) else {
            throw ContextError.windowCreationError
        }
        return window
    }

    func adjustViewport() throws {
        try ensureGLReady()
        viewPortSize = try requireCurrentWindow().size
    }

    func loadGlad() throws {
        guard glVersionDidConfigure else { throw ContextError.glVersionDidNotSet }
        guard currentWindowDidSet else { throw ContextError.currentWindowDidNotSet }
        try GLAD.load()
        gladDidLoad = true
    }

    func clear(color: Color) {
        glClearColor(color.cRed, color.cGreen, color.cBlue, color.cAlpha);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }

    func processInput() throws {
        try requireCurrentWindow().processInput(inputProcessor)
    }

    private func requireCurrentWindow() throws -> Window {
        guard let currentWindow else { throw ContextError.currentWindowDidNotSet }
        return currentWindow
    }

    private func viewPortSizeDidSet() {
        glViewport(0, 0, viewPortSize.cWidth, viewPortSize.cHeight);
    }

    deinit {
        glfwTerminate()
    }
}

extension Context: WindowContext {
    func didMakeCurrent(window: Window) {
        currentWindow = window
    }

    func ensureGLReady() throws {
        guard gladDidLoad else { throw ContextError.gladDidNotLoad }
    }

    func windowDidChangeSize(_ window: Window) {
        if currentWindow === window {
            viewPortSize = window.size
        }
    }
}
