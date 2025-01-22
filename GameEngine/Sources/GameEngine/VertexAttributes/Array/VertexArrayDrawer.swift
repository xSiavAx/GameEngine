import C_GLAD

protocol VertexArrayDrawer {
    func draw()
}

final class ArraysVertexArrayDrawer: VertexArrayDrawer {
    let mode: DrawMode
    let first: Int32
    let count: Int32

    init(mode: DrawMode, first: Int32, count: Int) {
        self.mode = mode
        self.first = first
        self.count = Int32(count)
    }

    func draw() {
        c_glDrawArrays(mode.gl, first, count)
    }
}

final class ElementsVertexArrayDrawer<T: GLType>: VertexArrayDrawer {
    let mode: DrawMode
    let count: Int
    let offset: Int?

    init(mode: DrawMode, count: Int, offset: Int? = nil) {
        self.mode = mode
        self.count = count
        self.offset = offset
    }

    func draw() {
        c_glDrawElements(mode.gl, Int32(count), T.glVal, offsetPointer)
    }

    private var offsetPointer: UnsafeRawPointer? {
        guard let offset else { return nil }
        let unsafeRawPointer = UnsafeRawPointer(bitPattern: 0x1)! - 1

        return unsafeRawPointer + offset * T.size
    }
}
