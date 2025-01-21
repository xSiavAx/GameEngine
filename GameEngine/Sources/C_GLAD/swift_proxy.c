#include "swift_proxy.h"

void c_glShaderSourceSingle(GLuint shader, const GLchar *string) {
    glShaderSource(shader, 1, &string, NULL);
}

void c_glGenBuffers(GLsizei n, GLuint * buffers) {
    glGenBuffers(n, buffers);
}

void c_glDeleteBuffers(GLsizei n, const GLuint* buffers) {
    glDeleteBuffers(n, buffers);
}

void c_glBindBuffer(GLenum target, GLuint buffer) {
    glBindBuffer(target, buffer);
}

void c_glBufferData(GLenum target, GLsizeiptr size, const void* data, GLenum usage) {
    glBufferData(target, size, data, usage);
}

void c_glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void * pointer) {
    glVertexAttribPointer(index, size, type, normalized, stride, pointer);
}

void c_glEnableVertexAttribArray(GLuint index) {
    glEnableVertexAttribArray(index);
}

void c_glBindVertexArray(GLuint array) {
    glBindVertexArray(array);
}

void c_glGenVertexArrays(GLsizei n, GLuint* arrays) {
    glGenVertexArrays(n, arrays);
}

void c_glDeleteVertexArrays(GLsizei n, const GLuint* arrays) {
    glDeleteVertexArrays(n, arrays);
}

GLuint c_glCreateShader(GLenum shaderType) {
    return glCreateShader(shaderType);
}

void c_glDeleteShader(GLuint shader) {
    glDeleteShader(shader);
}

void c_glShaderSource(GLuint shader, GLsizei count, const GLchar** string, const GLint* length) {
    glShaderSource(shader, count, string, length);
}

void c_glCompileShader(GLuint shader) {
    glCompileShader(shader);
}

void c_glGetShaderiv(GLuint shader, GLenum pname, GLint* params) {
    glGetShaderiv(shader, pname, params);
}

void c_glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei* length, GLchar* infoLog) {
    glGetShaderInfoLog(shader, maxLength, length, infoLog);
}

GLuint c_glCreateProgram() {
    return glCreateProgram();
}

void c_glDeleteProgram(GLuint program) {
    glDeleteProgram(program);
}

void c_glAttachShader(GLuint program, GLuint shader) {
    glAttachShader(program, shader);
}

void c_glLinkProgram(GLuint program) {
    glLinkProgram(program);
}

void c_glGetProgramiv(GLuint program, GLenum pname, GLint* params) {
    glGetProgramiv(program, pname, params);
}

void c_glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei* length, GLchar* infoLog) {
    glGetProgramInfoLog(program, maxLength, length, infoLog);
}

void c_glUseProgram(GLuint program) {
    glUseProgram(program);
}

void c_glDrawArrays(GLenum mode, GLint first, GLsizei count) {
    glDrawArrays(mode, first, count);
}

void c_glDrawElements(GLenum mode, GLsizei count, GLenum type, const void * indices) {
    glDrawElements(mode, count, type, indices);
}

void c_glPolygonMode(GLenum face, GLenum mode) {
    glPolygonMode(face, mode);
}

GLint c_glGetUniformLocation(GLuint program, const GLchar* name) {
    return glGetUniformLocation(program, name);
}

void c_glUniform1f(GLint location, GLfloat v0) {
    glUniform1f(location, v0);
}

void c_glUniform2f(GLint location, GLfloat v0, GLfloat v1) {
    glUniform2f(location, v0, v1);
}

void c_glUniform3f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2) {
    glUniform3f(location, v0, v1, v2);
}

void c_glUniform4f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) {
    glUniform4f(location, v0, v1, v2, v3);
}

void c_glUniform1i(GLint location, GLint v0) {
    glUniform1i(location, v0);
}

void c_glUniform2i(GLint location, GLint v0, GLint v1) {
    glUniform2i(location, v0, v1);
}

void c_glUniform3i(GLint location, GLint v0, GLint v1, GLint v2) {
    glUniform3i(location, v0, v1, v2);
}

void c_glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3) {
    glUniform4i(location, v0, v1, v2, v3);
}

void c_glUniform1ui(GLint location, GLuint v0) {
    glUniform1ui(location, v0);
}

void c_glUniform2ui(GLint location, GLuint v0, GLuint v1) {
    glUniform2ui(location, v0, v1);
}

void c_glUniform3ui(GLint location, GLuint v0, GLuint v1, GLuint v2) {
    glUniform3ui(location, v0, v1, v2);
}

void c_glUniform4ui(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) {
    glUniform4ui(location, v0, v1, v2, v3);
}

void c_glUniform1fv(GLint location, GLsizei count, const GLfloat* value) {
    glUniform1fv(location, count, value);
}

void c_glUniform2fv(GLint location, GLsizei count, const GLfloat* value) {
    glUniform2fv(location, count, value);
}

void c_glUniform3fv(GLint location, GLsizei count, const GLfloat* value) {
    glUniform3fv(location, count, value);
}

void c_glUniform4fv(GLint location, GLsizei count, const GLfloat* value) {
    glUniform4fv(location, count, value);
}

void c_glUniform1iv(GLint location, GLsizei count, const GLint* value) {
    glUniform1iv(location, count, value);
}

void c_glUniform2iv(GLint location, GLsizei count, const GLint* value) {
    glUniform2iv(location, count, value);
}

void c_glUniform3iv(GLint location, GLsizei count, const GLint* value) {
    glUniform3iv(location, count, value);
}

void c_glUniform4iv(GLint location, GLsizei count, const GLint* value) {
    glUniform4iv(location, count, value);
}

void c_glUniform1uiv(GLint location, GLsizei count, const GLuint* value) {
    glUniform1uiv(location, count, value);
}

void c_glUniform2uiv(GLint location, GLsizei count, const GLuint* value) {
    glUniform2uiv(location, count, value);
}

void c_glUniform3uiv(GLint location, GLsizei count, const GLuint* value) {
    glUniform3uiv(location, count, value);
}

void c_glUniform4uiv(GLint location, GLsizei count, const GLuint* value) {
    glUniform4uiv(location, count, value);
}

void c_glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix2fv(location, count, transpose, value);
}

void c_glUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix3fv(location, count, transpose, value);
}

void c_glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix4fv(location, count, transpose, value);
}

void c_glUniformMatrix2x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix2x3fv(location, count, transpose, value);
}

void c_glUniformMatrix3x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix3x2fv(location, count, transpose, value);
}

void c_glUniformMatrix2x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix2x4fv(location, count, transpose, value);
}

void c_glUniformMatrix4x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix4x2fv(location, count, transpose, value);
}

void c_glUniformMatrix3x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix3x4fv(location, count, transpose, value);
}

void c_glUniformMatrix4x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value) {
    glUniformMatrix4x3fv(location, count, transpose, value);
}

