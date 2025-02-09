extension RawRepresentable where RawValue: UniformType {
    func bind(location: Int32) {
        rawValue.bind(location: location)
    }
}
