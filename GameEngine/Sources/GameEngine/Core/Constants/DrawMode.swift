import C_GLAD

struct DrawMode {
    let gl: UInt32

    static let triangles = m(GL_TRIANGLES)

    private init(gl: UInt32) {
        self.gl = gl
    }

    private static func m(_ val: Int32) -> Self {
        return .init(gl: UInt32(val))
    }
}