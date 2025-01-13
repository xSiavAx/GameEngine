struct ISize {
    var width: Int
    var height: Int

    var cWidth: Int32 { Int32(width) }
    var cHeight: Int32 { Int32(height) }

    static let zero = ISize(width: 0, height: 0)

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    init(width: Int32, height: Int32) {
        self.init(width: Int(width), height: Int(height))
    }
}
