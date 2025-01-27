import Foundation
import C_GLAD

extension Float: UniformType, UniformComponent {
    func bind(location: Int32) {
        c_glUniform1f(location, self)
    }

    static func bind(_ val: SIMD2<Float>, location: Int32) {
        c_glUniform2f(location, val.x, val.y)
    }

    static func bind(_ val: SIMD3<Float>, location: Int32) {
        c_glUniform3f(location, val.x, val.y, val.z)
    }

    static func bind(_ val: SIMD4<Float>, location: Int32) {
        c_glUniform4f(location, val.x, val.y, val.z, val.w)
    }
}
