import C_GLAD
import Foundation

enum ShaderError: Error {
    case compileError(String)
    case noTextInProvidedFile(FileLoader)
}

final class Shader {
    private let name: UInt32

    var attachID: UInt32 { return name }

    init(kind: UInt32) {
        name = c_glCreateShader(kind)
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

    static func make(kind: UInt32, content: String) throws -> Shader {
        let shader = Shader(kind: kind)

        shader.load(content: content)
        try shader.compile()

        return shader
    }

    static func make(kind: UInt32, fileLolader: FileLoader) throws -> Shader {
        let data = try fileLolader.load()
        guard let content = String(data: data, encoding: .utf8) else { throw ShaderError.noTextInProvidedFile(fileLolader) }

        return try make(kind: kind, content: content)
    }

    static func make(kind: UInt32, url: URL) throws -> Shader {
        return try make(kind: kind, fileLolader: DefaultFileLoader(url: url))
    }

    static func make(kind: UInt32, name: String) throws -> Shader {
        return try make(kind: kind, fileLolader: try BundleFileLoader(title: name, ext: "gs"))
    }
}
