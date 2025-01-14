import C_GLAD
import Foundation

enum ShaderError: Error {
    case compileError(String)
}

final class Shader {
    private let name: UInt32

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
        var success: Int32 = 0

        c_glCompileShader(name)
        c_glGetShaderiv(name, C_GL_COMPILE_STATUS, &success);
        if success == 0 {
            let msg = UnsafeMutableBufferPointer<Int8>.allocate(capacity: 512)

            defer { msg.deallocate() }

            c_glGetShaderInfoLog(name, 512, nil, msg.baseAddress)
            throw ShaderError.compileError(String(cString: msg.baseAddress!))
        }
    }

    static func make(kind: UInt32, content: String) throws -> Shader {
        let shader = Shader(kind: kind)

        shader.load(content: content)
        try shader.compile()

        return shader
    }
}

enum ShaderLoadError: Error {
    case noTextInProvidedFile(FileLoader)
}

final class ShaderLoader {
    static func prepare(kind: UInt32, fileLolader: FileLoader) throws -> Shader {
        let data = try fileLolader.load()
        guard let content = String(data: data, encoding: .utf8) else { throw ShaderLoadError.noTextInProvidedFile(fileLolader) }

        return try Shader.make(kind: kind, content: content)
    }

    static func prepare(kind: UInt32, url: URL) throws -> Shader {
        return try prepare(kind: kind, fileLolader: DefaultFileLoader(url: url))
    }

    static func prepare(kind: UInt32, name: String) throws -> Shader {
        return try prepare(kind: kind, fileLolader: try BundleFileLoader(title: name, ext: "gs"))
    }
}
