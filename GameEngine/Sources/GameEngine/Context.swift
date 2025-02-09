import C_GL
import C_GLFW
import OpenCombineShim

enum ContextError: Error {
    case initializatioError
    case windowCreationError
    case currentWindowDidNotSet
}

final class Context {
    private(set) var currentWindow: Window?
    private(set) var glVersionDidConfigure = false
    private(set) var gladDidLoad = false

    private var clearMask = C_GL_COLOR_BUFFER_BIT

    var isDepthTestEnabled = false {
        didSet {
            if isDepthTestEnabled {
                clearMask |= C_GL_DEPTH_BUFFER_BIT
                glEnable(C_GL_DEPTH_TEST)
            } else {
                clearMask &= ~C_GL_DEPTH_BUFFER_BIT
                glDisable(C_GL_DEPTH_TEST)
            }
        }
    }    

    @Published
    var viewPort: ISize = .zero {
        didSet { glViewport(0, 0, viewPort.cWidth, viewPort.cHeight) }
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
        let window = try requireCurrentWindow()

        assert(gladDidLoad, "GLAD is not loaded")

        viewPort = window.size
        window.setupResizeHandler()
    }

    func loadGlad() throws {
        guard currentWindow != nil else { throw ContextError.currentWindowDidNotSet }

        assert(glVersionDidConfigure, "GL version is not set")
        try GLAD.load()
        gladDidLoad = true
    }

    func clear(color: Color) {
        glClearColor(color.cRed, color.cGreen, color.cBlue, color.cAlpha);
        glClear(clearMask)
    }

    func processInput() throws {
        try requireCurrentWindow().processInput()
    }

    func requireCurrentWindow() throws -> Window {
        guard let currentWindow else { throw ContextError.currentWindowDidNotSet }
        return currentWindow
    }

    deinit {
        glfwTerminate()
    }
}

extension Context: WindowContext {
    func didMakeCurrent(window: Window) {
        currentWindow = window
    }

    func windowDidChangeSize(_ window: Window) {
        if currentWindow === window {
            viewPort = window.size
        }
    }
}
