import C_GL
import C_GLAD

protocol TextureParameter {
    func apply(type: TextureType, property: TextureProperty)
}

protocol TextureParameterI: TextureParameter {}
extension TextureParameterI where Self: GLConstantRepresentable, T == Int32 {
    func apply(type: TextureType, property: TextureProperty) {
        c_glTexParameteri(type.gl, property.gl, gl)
    }
}
