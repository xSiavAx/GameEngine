import simd
import C_GLAD

extension simd_float4x4: UniformType {
    func bind(location: Int32) {
        withUnsafePointer(to: self) {
            $0.withMemoryRebound(to: Float.self, capacity: 16) {
                c_glUniformMatrix4fv(location, 1, false.gl, $0)
            }
        }
    }
}