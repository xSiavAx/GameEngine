import C_GLAD

typealias GLBufferObject = GLDataObject<GLBufferName, GLBufferNames>
typealias GLBufferSingle = GLDataSingle<GLBufferName, GLBufferNames>

extension GLBufferObject {
    convenience init(types: [BufferType]) {
        self.init(names: GLBufferNames(types: types)) {
            c_glBindBuffer($0.type.gl, $0.id)
        }
    }
}

extension GLBufferSingle {
    convenience init(type: BufferType) {
        self.init(types: [type])
    }
}
