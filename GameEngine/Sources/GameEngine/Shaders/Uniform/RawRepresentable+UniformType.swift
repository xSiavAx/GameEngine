extension RawRepresentable where RawValue: UniformType {
    func bind(uniform location: Int32) {
        rawValue.bind(uniform: location)
    }
}
