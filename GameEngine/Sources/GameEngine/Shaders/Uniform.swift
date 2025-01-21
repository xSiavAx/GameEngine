protocol UniformType {
    func bind(location: Int32)
}

struct Uniform<T: UniformType> {
    let name: String
    let location: Int32

    func bind(_ val: T) {
        val.bind(location: location)
    }
}


// void c_glUniform1i(GLint location, GLint v0);
// void c_glUniform2i(GLint location, GLint v0, GLint v1);
// void c_glUniform3i(GLint location, GLint v0, GLint v1, GLint v2);
// void c_glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
// void c_glUniform1ui(GLint location, GLuint v0);
// void c_glUniform2ui(GLint location, GLuint v0, GLuint v1);
// void c_glUniform3ui(GLint location, GLuint v0, GLuint v1, GLuint v2);
// void c_glUniform4ui(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
// void c_glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix2x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix3x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix2x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix4x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix3x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
// void c_glUniformMatrix4x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);

// Not needed (probably)
// void c_glUniform1fv(GLint location, GLsizei count, const GLfloat* value);
// void c_glUniform2fv(GLint location, GLsizei count, const GLfloat* value);
// void c_glUniform3fv(GLint location, GLsizei count, const GLfloat* value);
// void c_glUniform4fv(GLint location, GLsizei count, const GLfloat* value);
// void c_glUniform1iv(GLint location, GLsizei count, const GLint* value);
// void c_glUniform2iv(GLint location, GLsizei count, const GLint* value);
// void c_glUniform3iv(GLint location, GLsizei count, const GLint* value);
// void c_glUniform4iv(GLint location, GLsizei count, const GLint* value);
// void c_glUniform1uiv(GLint location, GLsizei count, const GLuint* value);
// void c_glUniform2uiv(GLint location, GLsizei count, const GLuint* value);
// void c_glUniform3uiv(GLint location, GLsizei count, const GLuint* value);
// void c_glUniform4uiv(GLint location, GLsizei count, const GLuint* value);