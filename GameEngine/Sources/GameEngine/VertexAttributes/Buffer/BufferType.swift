import C_GLAD

struct BufferType {
    let gl: UInt32

    static let array = m(GL_ARRAY_BUFFER)
    static let elementsArray = m(GL_ELEMENT_ARRAY_BUFFER)

    private init(gl: UInt32) {
        self.gl = gl
    }

    private static func m(_ val: Int32) -> Self {
        return .init(gl: UInt32(val))
    }
}