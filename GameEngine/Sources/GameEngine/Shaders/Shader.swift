import C_GLAD
import Foundation

private let C_GL_COMPILE_STATUS = UInt32(GL_COMPILE_STATUS)

enum ShaderError: Error {
    case compileError(String)
    case noTextInProvidedFile(FileLoader)
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

    static func make(type: ShaderType, fileLolader: FileLoader) throws -> Shader {
        let data = try fileLolader.load()
        guard let content = String(data: data, encoding: .utf8) else { throw ShaderError.noTextInProvidedFile(fileLolader) }

        return try make(type: type, content: content)
    }

    static func make(type: ShaderType, url: URL) throws -> Shader {
        return try make(type: type, fileLolader: DefaultFileLoader(url: url))
    }

    static func make(type: ShaderType, name: String) throws -> Shader {
        return try make(type: type, fileLolader: try BundleFileLoader(title: name, ext: "gs"))
    }
}
