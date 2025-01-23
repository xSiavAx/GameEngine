import C_GLAD
import Foundation

private let C_GL_COMPILE_STATUS = UInt32(GL_COMPILE_STATUS)

enum ShaderError: Error {
    case compileError(String)
}

final class Shader {
    private let name: UInt32

    var attachID: UInt32 { return name }

    init(type: ShaderType) {
        name = c_glCreateShader(type.gl)
    }

    deinit {
        c_glDeleteShader(name)
    }

    func load(content: String) {
        content.withCString { contentPtr in
            c_glShaderSourceSingle(name, contentPtr);
        }
    }

    func compile() throws {
        c_glCompileShader(name)

        try GLErrorChecker.check(
            isSuccess: {  c_glGetShaderiv(name, C_GL_COMPILE_STATUS, &$0) },
            getMessage: { c_glGetShaderInfoLog(name, $0, nil, $1) },
            makeError: { ShaderError.compileError($0) }
        )
    }

    static func make(type: ShaderType, content: String) throws -> Shader {
        let shader = Shader(type: type)

        shader.load(content: content)
        try shader.compile()

        return shader
    }

    static func load(type: ShaderType, url: URL) throws -> Shader {
        return try ShaderLoad(url: url, map: URLShaderMapper(type: type))()
    }

    static func load(type: ShaderType, resourceName: String) throws -> Shader {
        return try ShaderLoad(
            url: BundleURLProvider(name: resourceName, ext: "gs"), 
            map: URLShaderMapper(type: type)
        )()
    }
}

private final class StringShaderMapper: Mapper {
    let type: ShaderType

    init(type: ShaderType) {
        self.type = type
    }

    func callAsFunction(_ input: String) throws -> Shader {
        return try .make(type: type, content: input)
    }
}

private typealias DataShaderMapper = MapProxy<DataStringMapper, StringShaderMapper>

private final class URLShaderMapper: MapProxy<DataLoader, DataShaderMapper> {
    init(type: ShaderType) {
        let strToShader = StringShaderMapper(type: type)
        let dataToShader = DataShaderMapper(left: DataStringMapper(), right: strToShader)
        super.init(left: DataLoader(), right: dataToShader)
    }
}

private class ShaderLoad: FileBasedObjectLoad<Shader, URLShaderMapper> {}

