import C_GLAD
import C_GLFW

enum GLADError: Error {
    case unableToLoadGetProcAddress
}

struct GLAD {
    static func load() throws {
        guard load() else {
            throw GLADError.unableToLoadGetProcAddress
        }   
    }

    private static func load() -> Bool {
        gladLoadGLLoader({
            unsafeBitCast(glfwGetProcAddress($0), to: UnsafeMutableRawPointer.self)
        }) != 0
    }
}