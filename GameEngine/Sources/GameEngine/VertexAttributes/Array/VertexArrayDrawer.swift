import C_GLAD

protocol VertexArrayDrawer {
    func draw()
}

extension VertexArrayDrawer where Self == ArraysVertexArrayDrawer {
    static func arrays(mode: DrawMode, first: Int32 = 0, count: Int32) -> ArraysVertexArrayDrawer {
        ArraysVertexArrayDrawer(mode: mode, first: first, count: count)
    }
}

final class ArraysVertexArrayDrawer: VertexArrayDrawer {
    let mode: DrawMode
    let first: Int32
    let count: Int32

    init(mode: DrawMode, first: Int32, count: Int32) {
        self.mode = mode
        self.first = first
        self.count = count
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
        let unsafeRawPointer = UnsafeRawPointer(bitPattern: 0)!

        return unsafeRawPointer + offset * T.size
    }
}

extension GLBufferName.BoundParams {
    func arraysDrawer(mode: DrawMode) -> VertexArrayDrawer {
        .arrays(mode: mode, count: Int32(elementsCount))
    }

    func elementsDrawer(mode: DrawMode) -> VertexArrayDrawer {
        ElementsVertexArrayDrawer<T>(mode: mode, count: elementsCount)
    }
}
