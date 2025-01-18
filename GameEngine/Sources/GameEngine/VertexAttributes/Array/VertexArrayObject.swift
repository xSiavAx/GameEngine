import C_GLAD

typealias VertexArrayObject = GLDataObject<VertexArrayName, VertexArrayNames>
typealias VertexArraySingle = GLDataSingle<VertexArrayName, VertexArrayNames>

extension VertexArrayObject {
    convenience init(count: Int = 1) {
        self.init(
            names: VertexArrayNames(count: count),
            bind: { c_glBindVertexArray($0.id) },
            unbind: { _ in c_glBindVertexArray(0) }
        )
    }

    // For manual draw, use try vao.bind { idx, name in try name.draw() }
    func draw() throws {
        try bind { _, name in
            try name.draw()
        }
    }
}
