protocol UniformComponent: SIMDScalar, Decodable, Encodable, Hashable, Equatable {
    static func bind(_ val: SIMD2<Self>, uniform location: Int32)
    static func bind(_ val: SIMD3<Self>, uniform location: Int32)
    static func bind(_ val: SIMD4<Self>, uniform location: Int32)
}

extension SIMD2: UniformType where Scalar: UniformComponent {
    func bind(uniform location: Int32) {
        Scalar.bind(self, uniform: location)
    }
}

extension SIMD3: UniformType where Scalar: UniformComponent {
    func bind(uniform location: Int32) {
        Scalar.bind(self, uniform: location)
    }
}

extension SIMD4: UniformType where Scalar: UniformComponent {
    func bind(uniform location: Int32) {
        Scalar.bind(self, uniform: location)
    }
}
