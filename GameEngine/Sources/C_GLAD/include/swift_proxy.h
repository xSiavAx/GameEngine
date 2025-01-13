#include "glad.h"

void c_glGenBuffers(GLsizei n, GLuint * buffers);
void c_glDeleteBuffers(GLsizei n, const GLuint *buffers);
void c_glBindBuffer(GLenum target, GLuint buffer);
void c_glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage);
