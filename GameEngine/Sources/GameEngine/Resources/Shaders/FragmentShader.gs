#version 330 core

in vec3 color;
in vec2 texCoord;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform vec3 lightColor;

out vec4 FragColor;

void main()
{
    // FragColor = mix(
    //     texture(texture0, texCoord),
    //     texture(texture1, texCoord),
    //     0.2
    // ) * vec4(color, 1.0);
    FragColor = vec4(lightColor * color, 1.0);
}

// void main()
// {
//     FragColor = vec4(lightColor * objectColor, 1.0);
// }