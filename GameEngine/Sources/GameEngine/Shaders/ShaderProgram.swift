import C_GLAD

enum ShaderProgramError: Error {
    case linkError(String)
}

final class ShaderProgram {
    let name = c_glCreateProgram()

    func attach(shader: Shader) {
        c_glAttachShader(name, shader.attachID);
    }

    func attach(shaders: [Shader]) {
        shaders.forEach(attach(shader:))
    }

    func link() throws {
        c_glLinkProgram(name)
        try GLErrorChecker.check(
            isSuccess: {  c_glGetProgramiv(name, C_GL_LINK_STATUS, &$0) },
            getMessage: { c_glGetProgramInfoLog(name, $0, nil, $1) },
            makeError: { ShaderProgramError.linkError($0) }
        )
    }

    func use() {
        c_glUseProgram(name)
    }

    func use(shaders: [Shader]) throws {
        attach(shaders: shaders)
        try link()
        use()
    }

    deinit {
        c_glDeleteProgram(name)
    }
}
