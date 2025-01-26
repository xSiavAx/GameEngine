protocol TextureConfig {
    func apply(type: TextureType)
}

extension TextureConfig where Self == TextureConfigList {
    static func wrap(s: WrappingMode, t: WrappingMode) -> TextureConfigList {
        TextureConfigList(configs: [wrapS(s), wrapT(t)])
    }

    static func filter(min: MinFilter, mag: MagFilter) -> TextureConfigList {
        TextureConfigList(configs: [minFilter(min), magFilter(mag)])
    }
}

extension TextureConfig {
    typealias WrappingMode = Texture.WrappingMode
    typealias GenericConfig = Texture.GenericConfig
    typealias MinFilter = Texture.MinFilter
    typealias MagFilter = Texture.MagFilter

    static func minFilter( _ value: MinFilter) -> GenericConfig<MinFilter> {
        GenericConfig(property: .minFilter, parameter: value)
    }

    static func magFilter( _ value: MagFilter) -> GenericConfig<MagFilter> {
        GenericConfig(property: .magFilter, parameter: value)
    }

    static func wrapS(_ value: WrappingMode) -> GenericConfig<WrappingMode> {
        GenericConfig(property: .wrapS, parameter: value)
    }

    static func wrapT(_ value: WrappingMode) -> GenericConfig<WrappingMode> {
        GenericConfig(property: .wrapT, parameter: value)
    }
}

struct TextureConfigList: TextureConfig {
    let configs: [TextureConfig]

    func apply(type: TextureType) {
        configs.forEach { $0.apply(type: type) }
    }
}

extension Texture {
    struct GenericConfig<Parameter: TextureParameter>: TextureConfig {
        let property: TextureProperty
        let parameter: Parameter

        func apply(type: TextureType) {
            parameter.apply(type: type, property: property)
        }
    }
}
