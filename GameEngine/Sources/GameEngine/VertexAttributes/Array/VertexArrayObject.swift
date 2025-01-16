import C_GLAD

typealias VertexArrayObject = GLDataObject<VertexArrayName, VertexArrayNames>
typealias VertexArraySingle = GLDataSingle<VertexArrayName, VertexArrayNames>

extension VertexArrayObject {
    convenience init(count: Int = 1) {
        self.init(names: VertexArrayNames(count: count)) {
            c_glBindVertexArray($0.id)
        }
    }
}

extension VertexArraySingle {
    func bind() {
        bind { _ in }
    }
}
