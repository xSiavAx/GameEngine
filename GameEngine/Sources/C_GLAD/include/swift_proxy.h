#include "glad.h"

void c_glGenBuffers(GLsizei n, GLuint * buffers);
void c_glDeleteBuffers(GLsizei n, const GLuint *buffers);
void c_glBindBuffer(GLenum target, GLuint buffer);
void c_glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage);

void c_glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void * pointer);
void c_glEnableVertexAttribArray(GLuint index);
void c_glBindVertexArray(GLuint array);

void c_glGenVertexArrays(GLsizei n, GLuint *arrays);
void c_glDeleteVertexArrays(GLsizei n, const GLuint *arrays);

GLuint c_glCreateShader(  GLenum shaderType);
void c_glDeleteShader(GLuint shader);
void c_glShaderSource(GLuint shader, GLsizei count, const GLchar **string, const GLint *length);
void c_glShaderSourceSingle(GLuint shader, const GLchar *string);
void c_glCompileShader(GLuint shader);
void c_glGetShaderiv(GLuint shader, GLenum pname, GLint *params);
void c_glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog);

GLuint c_glCreateProgram();
void c_glDeleteProgram(GLuint program);
void c_glAttachShader(GLuint program, GLuint shader);
void c_glLinkProgram(GLuint program);
void c_glGetProgramiv(GLuint program, GLenum pname, GLint *params);
void c_glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
void c_glUseProgram(GLuint program);


void c_glDrawArrays(GLenum mode, GLint first, GLsizei count);
void c_glDrawElements(GLenum mode, GLsizei count, GLenum type, const void * indices);

