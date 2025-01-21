import Foundation
import C_GLAD

extension Float: UniformType {
    func bind(location: Int32) {
        c_glUniform1f(location, self)
    }
}

extension SIMD2: UniformType where Scalar == Float {
    func bind(location: Int32) {
        c_glUniform2f(location, x, y)
    }
}


extension SIMD3: UniformType where Scalar == Float {
    func bind(location: Int32) {
        c_glUniform3f(location, x, y, z)
    }
}

extension SIMD4: UniformType where Scalar == Float {
    func bind(location: Int32) {
        c_glUniform4f(location, x, y, z, w)
    }
}
