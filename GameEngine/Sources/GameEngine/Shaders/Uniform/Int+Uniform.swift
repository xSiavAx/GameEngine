import Foundation
import C_GLAD

extension Int32: UniformType {
    func bind(location: Int32) {
        c_glUniform1i(location, self)
    }

    static func bind(_ val: SIMD2<Int32>, location: Int32) {
        c_glUniform2i(location, val.x, val.y)
    }

    static func bind(_ val: SIMD3<Int32>, location: Int32) {
        c_glUniform3i(location, val.x, val.y, val.z)
    }

    static func bind(_ val: SIMD4<Int32>, location: Int32) {
        c_glUniform4i(location, val.x, val.y, val.z, val.w)
    }
}
