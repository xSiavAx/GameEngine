import C_GL
import C_GLAD

final class VertexBufferObjects {
    private var arrayBufferNames: BufferNames
    

    init(numberOfArrayBuffers: Int = 1) {
        arrayBufferNames = BufferNames(count: numberOfArrayBuffers)

        arrayBufferNames.bind(type: C_GL_ARRAY_BUFFER)     
    }

    func addToArrayBuffer(_ data: [Float]) {
        let len = MemoryLayout<Float>.size * data.count

        data.withUnsafeBufferPointer { buffer in
            print("Size is \(len)")
            c_glBufferData(C_GL_ARRAY_BUFFER, Int64(len), buffer.baseAddress, C_GL_STATIC_DRAW);
        }   
    }
}

final class BufferNames {
    private var names: UnsafeBufferPointer<UInt32>

    init(count: Int) {
        let names = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: count)

        c_glGenBuffers(Int32(names.count), names.baseAddress)
        self.names = UnsafeBufferPointer<UInt32>(names)
    }

    func bind(type: UInt32) {
        forEach {
            c_glBindBuffer(type, $0)
        }
    }

    func forEach(_ block: (UInt32) -> Void) {
        (0..<names.count).forEach {
            block(names[$0])
        }
    }

    deinit {
        c_glDeleteBuffers(Int32(names.count), names.baseAddress)
    }
}

