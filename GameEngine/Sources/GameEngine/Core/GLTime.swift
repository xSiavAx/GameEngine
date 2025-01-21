import C_GLFW

enum GLTime {
    static var now: Double { glfwGetTime() }
}