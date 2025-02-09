struct Color {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    var cRed: Float { Float(red) }
    var cGreen: Float { Float(green) }
    var cBlue: Float { Float(blue) }
    var cAlpha: Float { Float(alpha) }

    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(red: Int, green: Int, blue: Int, alpha: Double) {
        self.init(
            red: Double(red) / 0xff,
            green: Double(green) / 0xff,
            blue: Double(blue) / 0xff,
            alpha: alpha
        )
    }

    init(red: Int, green: Int, blue: Int, alpha: Int) {
        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: Double(alpha) / 0xff
        )
    }

    init(rgb: UInt32) {
        self.init(rgba: (rgb << 8) | 0xff)
    }

    init(rgba: UInt32) {
        self.init(
            red: Int(rgba >> 24),
            green: Int(rgba >> 16 & 0xff),
            blue: Int(rgba >> 8 & 0xff),
            alpha: Int(rgba & 0xff)
        )
    }

    var rgbVector: SIMD3<Float> { SIMD3(x: cRed, y: cGreen, z: cBlue) }
    var rgbaVector: SIMD4<Float> { SIMD4(x: cRed, y: cGreen, z: cBlue, w: cAlpha) }
}

extension Color {
    static let red = Color(rgb: 0xff0000)
    static let green = Color(rgb: 0x00ff00)
    static let blue = Color(rgb: 0x0000ff)
    static let black = Color(rgb: 0x000000)
    static let white = Color(rgb: 0xffffff)
    static let yellow = Color(rgb: 0xffff00)

    static let coral = Color(rgb: 0xff804f)
    static let limedSpruce = Color(rgb: 0x334D4D)
}
