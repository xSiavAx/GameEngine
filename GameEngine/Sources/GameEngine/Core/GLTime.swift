import C_GLFW

enum GLTime {
    static var now: Double { glfwGetTime() }
}

final class TimeDelta {
    private var lastTime = 0.0

    func reset() {
        lastTime = GLTime.now
    }

    func update() -> Float {
        let new = GLTime.now

        defer { lastTime = new }
        return Float(new - lastTime)
    }
}