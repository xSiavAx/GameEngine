#include "glad.h"

void c_glShaderSourceSingle(GLuint shader, const GLchar *string);
void c_glGenBuffers(GLsizei n, GLuint * buffers);
void c_glDeleteBuffers(GLsizei n, const GLuint* buffers);
void c_glBindBuffer(GLenum target, GLuint buffer);
void c_glBufferData(GLenum target, GLsizeiptr size, const void* data, GLenum usage);
void c_glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const void * pointer);
void c_glEnableVertexAttribArray(GLuint index);
void c_glBindVertexArray(GLuint array);
void c_glGenVertexArrays(GLsizei n, GLuint* arrays);
void c_glDeleteVertexArrays(GLsizei n, const GLuint* arrays);
GLuint c_glCreateShader(GLenum shaderType);
void c_glDeleteShader(GLuint shader);
void c_glShaderSource(GLuint shader, GLsizei count, const GLchar** string, const GLint* length);
void c_glCompileShader(GLuint shader);
void c_glGetShaderiv(GLuint shader, GLenum pname, GLint* params);
void c_glGetShaderInfoLog(GLuint shader, GLsizei maxLength, GLsizei* length, GLchar* infoLog);
GLuint c_glCreateProgram();
void c_glDeleteProgram(GLuint program);
void c_glAttachShader(GLuint program, GLuint shader);
void c_glLinkProgram(GLuint program);
void c_glGetProgramiv(GLuint program, GLenum pname, GLint* params);
void c_glGetProgramInfoLog(GLuint program, GLsizei maxLength, GLsizei* length, GLchar* infoLog);
void c_glUseProgram(GLuint program);
void c_glDrawArrays(GLenum mode, GLint first, GLsizei count);
void c_glDrawElements(GLenum mode, GLsizei count, GLenum type, const void * indices);
void c_glPolygonMode(GLenum face, GLenum mode);
GLint c_glGetUniformLocation(GLuint program, const GLchar* name);
void c_glUniform1f(GLint location, GLfloat v0);
void c_glUniform2f(GLint location, GLfloat v0, GLfloat v1);
void c_glUniform3f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
void c_glUniform4f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
void c_glUniform1i(GLint location, GLint v0);
void c_glUniform2i(GLint location, GLint v0, GLint v1);
void c_glUniform3i(GLint location, GLint v0, GLint v1, GLint v2);
void c_glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
void c_glUniform1ui(GLint location, GLuint v0);
void c_glUniform2ui(GLint location, GLuint v0, GLuint v1);
void c_glUniform3ui(GLint location, GLuint v0, GLuint v1, GLuint v2);
void c_glUniform4ui(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
void c_glUniform1fv(GLint location, GLsizei count, const GLfloat* value);
void c_glUniform2fv(GLint location, GLsizei count, const GLfloat* value);
void c_glUniform3fv(GLint location, GLsizei count, const GLfloat* value);
void c_glUniform4fv(GLint location, GLsizei count, const GLfloat* value);
void c_glUniform1iv(GLint location, GLsizei count, const GLint* value);
void c_glUniform2iv(GLint location, GLsizei count, const GLint* value);
void c_glUniform3iv(GLint location, GLsizei count, const GLint* value);
void c_glUniform4iv(GLint location, GLsizei count, const GLint* value);
void c_glUniform1uiv(GLint location, GLsizei count, const GLuint* value);
void c_glUniform2uiv(GLint location, GLsizei count, const GLuint* value);
void c_glUniform3uiv(GLint location, GLsizei count, const GLuint* value);
void c_glUniform4uiv(GLint location, GLsizei count, const GLuint* value);
void c_glUniformMatrix2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix2x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix3x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix2x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix4x2fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix3x4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glUniformMatrix4x3fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat* value);
void c_glGenTextures(GLsizei n, GLuint * textures);
void c_glDeleteTextures(GLsizei n, const GLuint * textures);
void c_glBindTexture(GLenum target, GLuint texture);
void c_glTexImage2D(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const void * data);
void c_glGenerateMipmap(GLenum target);
