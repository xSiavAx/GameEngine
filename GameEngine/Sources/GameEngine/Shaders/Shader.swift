import C_GLAD
import Foundation
import MapReduce

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
        return try url
            .map(UrlToData())
            .flatMap(DataToString().erase())
            .flatMap(StringToShader(type: type))
            .get()
    }

    static func load(type: ShaderType, resource: ResourceReference) throws -> Shader {
        let url = try resource.map(ResourceReferenceToUrl()).get()
        return try load(type: type, url: url)
    }

    static func load(type: ShaderType, resource: String) throws -> Shader {
        return try load(type: type, resource: ResourceReference(title: resource, ext: ".gs"))
    }
}

private final class StringToShader: FailingMapper {
    let type: ShaderType

    init(type: ShaderType) {
        self.type = type
    }

    func map(_ input: String) -> Result<Shader, Error> {
        return Result { try .make(type: type, content: input) }
    }
}
