#include "glad.h"

void c_glGenBuffers(GLsizei n, GLuint * buffers);
void c_glDeleteBuffers(GLsizei n, const GLuint *buffers);
void c_glBindBuffer(GLenum target, GLuint buffer);
void c_glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage);

GLuint c_glCreateShader(  GLenum shaderType);
void c_glShaderSource(GLuint shader, GLsizei count, const GLchar **string, const GLint *length);
void c_glShaderSourceSingle(GLuint shader, const GLchar *string);
void c_glCompileShader(GLuint shader);
void c_glGetShaderiv(GLuint shader, GLenum pname, GLint *params);
void c_glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
void c_glDeleteShader(GLuint shader);

