import C_GLAD

typealias GLBufferObject = GLDataObject<GLBufferName, GLBufferNames>
typealias GLBufferSingle = GLDataSingle<GLBufferName, GLBufferNames>

extension GLBufferObject {
    convenience init(types: [UInt32]) {
        self.init(names: GLBufferNames(types: types)) {
            c_glBindBuffer($0.type, $0.id)
        }
    }
}

extension GLBufferSingle {
    convenience init(type: UInt32) {
        self.init(types: [type])
    }
}
