import C_GLAD

private let C_GL_LINK_STATUS = UInt32(GL_LINK_STATUS)

enum ShaderProgramError: Error {
    case linkError(String)
    case uniformNotFound(String)
}

final class ShaderProgram {
    let id = c_glCreateProgram()

    func attach(shader: Shader) {
        c_glAttachShader(id, shader.attachID);
    }

    func attach(shaders: [Shader]) {
        shaders.forEach(attach(shader:))
    }

    func link() throws {
        c_glLinkProgram(id)
        try GLErrorChecker.check(
            isSuccess: {  c_glGetProgramiv(id, C_GL_LINK_STATUS, &$0) },
            getMessage: { c_glGetProgramInfoLog(id, $0, nil, $1) },
            makeError: { ShaderProgramError.linkError($0) }
        )
    }

    func use() {
        c_glUseProgram(id)
    }

    func use(shaders: [Shader]) throws {
        attach(shaders: shaders)
        try link()
        use()
    }

    func modeUniform() throws -> Uniform<ShaderMode> {
        return try getUniform(name: "mode")
    }

    func getUniform<T>(name: String) throws -> Uniform<T> {
        let location = c_glGetUniformLocation(id, name)
        guard location != -1 else { throw ShaderProgramError.uniformNotFound(name) }
        return Uniform(name: name, location: location)
    }

    deinit {
        c_glDeleteProgram(id)
    }
}
