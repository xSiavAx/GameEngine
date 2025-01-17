import C_GLAD

protocol VertexArrayDrawer {
    func draw()
}

extension VertexArrayDrawer where Self == ArraysVertexArrayDrawer {
    static func arrays(mode: UInt32, first: Int32 = 0, count: Int32) -> ArraysVertexArrayDrawer {
        ArraysVertexArrayDrawer(mode: mode, first: first, count: count)
    }
}

extension VertexArrayDrawer where Self == ElementsVertexArrayDrawer {
        static func elements(
        mode: UInt32,
        count: Int,
        elementSize: Int,
        glType: UInt32,
        offset: Int? = nil
    ) -> ElementsVertexArrayDrawer {
        ElementsVertexArrayDrawer(
            mode: mode,
            count: count,
            elementSize: elementSize,
            glType: glType,
            offset: offset
        )
    }

    static func elements<T>(
        mode: UInt32,
        count: Int,
        elementType: T.Type,
        glType: UInt32,
        offset: Int? = nil
    ) -> ElementsVertexArrayDrawer {
        ElementsVertexArrayDrawer(
            mode: mode,
            count: count,
            elementSize: MemoryLayout<T>.size,
            glType: glType,
            offset: offset
        )
    }
}

final class ArraysVertexArrayDrawer: VertexArrayDrawer {
    let mode: UInt32
    let first: Int32
    let count: Int32

    init(mode: UInt32, first: Int32, count: Int32) {
        self.mode = mode
        self.first = first
        self.count = count
    }

    func draw() {
        c_glDrawArrays(mode, first, count)
    }
}

final class ElementsVertexArrayDrawer: VertexArrayDrawer {
    let mode: UInt32
    let count: Int
    let glType: UInt32
    let elementSize: Int
    let offset: Int?

    init(mode: UInt32, count: Int, elementSize: Int, glType: UInt32, offset: Int? = nil) {
        self.mode = mode
        self.count = count
        self.elementSize = elementSize
        self.glType = glType
        self.offset = offset
    }

    convenience init<T>(mode: UInt32, count: Int, elementType: T.Type, glType: UInt32, offset: Int? = nil) {
        self.init(
            mode: mode,
            count: count,
            elementSize: MemoryLayout<T>.size,
            glType: glType,
            offset: offset
        )
    }

    func draw() {
        c_glDrawElements(mode, Int32(count), glType, offsetPointer)
    }

    private var offsetPointer: UnsafeRawPointer? {
        guard let offset else { return nil }
        let unsafeRawPointer = UnsafeRawPointer(bitPattern: 0)!

        return unsafeRawPointer + offset * elementSize
    }
}
