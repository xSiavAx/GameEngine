import C_GLAD

typealias VertexBufferObject = GLDataObject<VertexBufferName, VertexBufferNames>
typealias VertexBufferSingle = GLDataSingle<VertexBufferName, VertexBufferNames>

extension VertexBufferObject {
    convenience init(types: [UInt32]) {
        self.init(names: VertexBufferNames(types: types)) {
            c_glBindBuffer($0.type, $0.id)
        }
    }
}

extension VertexBufferSingle {
    convenience init(type: UInt32) {
        self.init(types: [type])
    }
}
