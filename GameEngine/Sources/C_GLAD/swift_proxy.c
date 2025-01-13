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
