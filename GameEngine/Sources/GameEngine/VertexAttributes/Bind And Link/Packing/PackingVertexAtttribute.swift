import simd

protocol PackingVertexAtttribute {
    func pack(into: inout UnsafeMutableRawPointer)
}

extension SIMD2: PackingVertexAtttribute where Scalar: GLType {}
extension SIMD3: PackingVertexAtttribute where Scalar: GLType {}
extension SIMD4: PackingVertexAtttribute where Scalar: GLType {}

extension SIMD where Scalar: GLType {
    static var glVal: UInt32 { Scalar.glVal }

    func pack(into ptr: inout UnsafeMutableRawPointer) {
        for i in (0..<scalarCount) {
            ptr.storeBytes(of: self[i], as: Scalar.self)
            ptr += Scalar.size
        }
    }
}
