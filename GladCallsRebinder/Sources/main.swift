import Foundation

let input = """

void glGenBuffers(GLsizei n, GLuint * buffers);
void glDeleteBuffers(GLsizei n, const GLuint *buffers);
void glBindBuffer(GLenum target, GLuint buffer);
void glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage);

void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void * pointer);
void glEnableVertexAttribArray(GLuint index);
void glBindVertexArray(GLuint array);

void glGenVertexArrays(GLsizei n, GLuint *arrays);
void glDeleteVertexArrays(GLsizei n, const GLuint *arrays);

GLuint glCreateShader(  GLenum shaderType);
void glDeleteShader(GLuint shader);
void glShaderSource(GLuint shader, GLsizei count, const GLchar **string, const GLint *length);
void glCompileShader(GLuint shader);
void glGetShaderiv(GLuint shader, GLenum pname, GLint *params);
void glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog);

GLuint glCreateProgram();
void glDeleteProgram(GLuint program);
void glAttachShader(GLuint program, GLuint shader);
void glLinkProgram(GLuint program);
void glGetProgramiv(GLuint program, GLenum pname, GLint *params);
void glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
void glUseProgram(GLuint program);


void glDrawArrays(GLenum mode, GLint first, GLsizei count);
void glDrawElements(GLenum mode, GLsizei count, GLenum type, const void * indices);

void glPolygonMode(GLenum face, GLenum mode);

GLint glGetUniformLocation(GLuint program, const GLchar *name);

void glUniform1f(   GLint location,
    GLfloat v0);
 
void glUniform2f(   GLint location,
    GLfloat v0,
    GLfloat v1);
 
void glUniform3f(   GLint location,
    GLfloat v0,
    GLfloat v1,
    GLfloat v2);
 
void glUniform4f(   GLint location,
    GLfloat v0,
    GLfloat v1,
    GLfloat v2,
    GLfloat v3);
 
void glUniform1i(   GLint location,
    GLint v0);
 
void glUniform2i(   GLint location,
    GLint v0,
    GLint v1);
 
void glUniform3i(   GLint location,
    GLint v0,
    GLint v1,
    GLint v2);
 
void glUniform4i(   GLint location,
    GLint v0,
    GLint v1,
    GLint v2,
    GLint v3);
 
void glUniform1ui(  GLint location,
    GLuint v0);
 
void glUniform2ui(  GLint location,
    GLuint v0,
    GLuint v1);
 
void glUniform3ui(  GLint location,
    GLuint v0,
    GLuint v1,
    GLuint v2);
 
void glUniform4ui(  GLint location,
    GLuint v0,
    GLuint v1,
    GLuint v2,
    GLuint v3);
 
void glUniform1fv(  GLint location,
    GLsizei count,
    const GLfloat *value);
 
void glUniform2fv(  GLint location,
    GLsizei count,
    const GLfloat *value);
 
void glUniform3fv(  GLint location,
    GLsizei count,
    const GLfloat *value);
 
void glUniform4fv(  GLint location,
    GLsizei count,
    const GLfloat *value);
 
void glUniform1iv(  GLint location,
    GLsizei count,
    const GLint *value);
 
void glUniform2iv(  GLint location,
    GLsizei count,
    const GLint *value);
 
void glUniform3iv(  GLint location,
    GLsizei count,
    const GLint *value);
 
void glUniform4iv(  GLint location,
    GLsizei count,
    const GLint *value);
 
void glUniform1uiv( GLint location,
    GLsizei count,
    const GLuint *value);
 
void glUniform2uiv( GLint location,
    GLsizei count,
    const GLuint *value);
 
void glUniform3uiv( GLint location,
    GLsizei count,
    const GLuint *value);
 
void glUniform4uiv( GLint location,
    GLsizei count,
    const GLuint *value);
 
void glUniformMatrix2fv(    GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix3fv(    GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix4fv(    GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix2x3fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix3x2fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix2x4fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix4x2fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix3x4fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
void glUniformMatrix4x3fv(  GLint location,
    GLsizei count,
    GLboolean transpose,
    const GLfloat *value);
 
"""

struct CIdentifier: CustomStringConvertible {
    let type: String
    let name: String

    var description: String { "\(type) \(name)" }

    init(rawString: String) {
        guard let sepratorIdx = rawString.lastIndex(of: " ") else { fatalError("Invalid Identifier \(rawString)") }
        let nameStart = rawString.index(sepratorIdx, offsetBy: 1)
        var type = String(rawString.prefix(upTo: sepratorIdx))
        var name = String(rawString.suffix(from: nameStart))

        while name.starts(with: "*") {
            name = String(name.suffix(name.count - 1))
            type += "*"
        }

        self.type = type
        self.name = name
    }

    func withName(prefix: String) -> String {
        return "\(type) \(prefix)\(name)"
    }
}

struct CFunction: CustomStringConvertible {
    let id: CIdentifier
    let arguments: [CIdentifier]

    var argumentsDescription: String { arguments.map { "\($0)" }.joined(separator: ", ") }
    var description: String { "\(id)(\(argumentsDescription))" }

    init(rawID: String, rawArguments: [String]) {
        self.id = CIdentifier(rawString: rawID)
        self.arguments = rawArguments.map { CIdentifier(rawString: $0) }
    }

    var asHeader: String { "\(signature);" }

    var asImplementation: String {
        return "\(signature) {\n    \(asBody)\n}\n"
    }

    var signature: String { "\(id.withName(prefix: "c_"))(\(argumentsDescription))" }

    var asCall: String {
        "\(id.name)(\(arguments.map(\.name).joined(separator: ", ")));"
    }

    var returnStmt: String? {
        return id.type == "void" ? nil : "return"
    }

    var asBody: String { [returnStmt, asCall].compactMap(\.self).joined(separator: " ") }
}

func getFunctions(input: String) -> [String] {
    return input
        .split(separator: ";\n")
        .map { String($0) }
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { $0.count > 0 }
}

func makeFunction(rawString: String) -> CFunction {
    guard let function = rawString
        .split(separator: ")")
        .first // remove ) and everything after
    else { fatalError("Can't find ) in \(rawString)") }
    let functionComponents = function.split(separator: "(").map { String($0) }
    let functionID = functionComponents.first!
    let functionArgs = makeArguments(components: functionComponents)

    return CFunction(rawID: functionID, rawArguments: functionArgs)
}

func makeArguments(components: [String]) -> [String] {
    guard components.count > 1 else { return [] }
    return components
            .last!
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
}

let functions = getFunctions(input: input)
    .map(makeFunction)

print("Header\n____________________")
print(functions.map(\.asHeader).joined(separator: "\n"))
print("--------------------------------")
print("Sources\n___________________")
print(functions.map(\.asImplementation).joined(separator: "\n"))