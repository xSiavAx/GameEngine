#include "swift_proxy.h"

void c_glGenBuffers(GLsizei n, GLuint * buffers) {
    glGenBuffers(n, buffers);
}

void c_glDeleteBuffers(GLsizei n, const GLuint *buffers) {
    glDeleteBuffers(n, buffers);
}

void c_glBindBuffer(GLenum target, GLuint buffer) {
    glBindBuffer(target, buffer);
}

void c_glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage) {
    glBufferData(target, size, data, usage);
}

GLuint c_glCreateShader( GLenum shaderType) {
    return glCreateShader(shaderType);
}

void c_glShaderSource(GLuint shader, GLsizei count, const GLchar **string, const GLint *length) {
    glShaderSource(shader, count, string, length);
}

void c_glShaderSourceSingle(GLuint shader, const GLchar *string) {
    glShaderSource(shader, 1, &string, NULL);
}

void c_glCompileShader(GLuint shader) {
    glCompileShader(shader);
}

void c_glGetShaderiv(GLuint shader, GLenum pname, GLint *params) {
    glGetShaderiv(shader, pname, params);
}

void c_glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog) {
    glGetShaderInfoLog(shader, maxLength, length, infoLog);
}

void c_glDeleteShader(GLuint shader) {
    glDeleteShader(shader);
}
