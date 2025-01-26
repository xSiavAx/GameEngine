#version 330 core

in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D aTexture;

out vec4 FragColor;

void main()
{
    FragColor = texture(aTexture, texCoord);
}
