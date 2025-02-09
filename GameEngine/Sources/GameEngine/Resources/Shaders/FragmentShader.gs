#version 330 core

in vec3 color;
in vec2 texCoord;

uniform sampler2D texture0;
uniform sampler2D texture1;

uniform vec3 lightColor;

// 1: Color
// 2: Texture
// 3: Light
uniform int mode;

out vec4 FragColor;

void main()
{
    if (mode == 1) {
        FragColor = vec4(lightColor * color, 1.0);
    } else if (mode == 2) {
        FragColor = mix(
            texture(texture0, texCoord),
            texture(texture1, texCoord),
            0.2
        ) * vec4(color, 1.0);
    } else if (mode == 3) {
        FragColor = vec4(lightColor, 1.0);
    } else {
        FragColor = vec4(0.0, 1.0, 0.0, 1.0);
    }
}
