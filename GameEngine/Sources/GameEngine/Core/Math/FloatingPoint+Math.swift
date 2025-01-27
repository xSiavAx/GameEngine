extension FloatingPoint {
    static func degrees(_ degrees: Self) -> Self {
        return degrees * .pi / 180
    }

    var asDegrees: Self {
        return self * 180 / .pi
    }
}