import C_GLAD

typealias GLBufferObject = GLDataObject<GLBufferName, GLBufferNames>
typealias GLBufferSingle = GLDataSingle<GLBufferName, GLBufferNames>

extension GLBufferObject {
    convenience init(types: [BufferType], unbindAutomatically: Bool = true) {
        self.init(
            names: GLBufferNames(types: types),
            bind: { c_glBindBuffer($0.type.gl, $0.id) },
            unbind: { c_glBindBuffer($0.type.gl, 0) },
            unbindAutomatically: unbindAutomatically
        )
    }
}

extension GLBufferSingle {
    convenience init(type: BufferType, unbindAutomatically: Bool = true) {
        self.init(types: [type], unbindAutomatically: unbindAutomatically)
    }
}
