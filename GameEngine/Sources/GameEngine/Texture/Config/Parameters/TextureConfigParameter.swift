import C_GL

protocol TextureParameter {
    func apply(type: TextureType, property: TextureProperty)
}

protocol TextureParameterI: TextureParameter {}
extension TextureParameterI where Self: GLConstantRepresentable, T == Int32 {
    func apply(type: TextureType, property: TextureProperty) {
        glTexParameteri(type.gl, property.gl, gl)
    }
}
