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


void c_glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void * pointer) {
    glVertexAttribPointer(index, size, type, normalized, stride, pointer);
}

void c_glEnableVertexAttribArray(GLuint index) { 
    glEnableVertexAttribArray(index);
}

void c_glGenVertexArrays(GLsizei n, GLuint *arrays) {
    glGenVertexArrays(n, arrays);
}

void c_glDeleteVertexArrays(GLsizei n, const GLuint *arrays) {
    glDeleteVertexArrays(n, arrays);
}

void c_glBindVertexArray(GLuint array) {
    glBindVertexArray(array);
}

GLuint c_glCreateShader( GLenum shaderType) {
    return glCreateShader(shaderType);
}

void c_glDeleteShader(GLuint shader) {
    glDeleteShader(shader);
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

void c_glGetProgramiv(GLuint program, GLenum pname, GLint *params) {
    glGetProgramiv(program, pname, params);
}

void c_glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog) {
    glGetProgramInfoLog(program, maxLength, length, infoLog);
}

void c_glUseProgram(GLuint program) {
    glUseProgram(program);
}
