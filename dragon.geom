#version 330 compatibility
#extension GL_EXT_gpu_shader4: enable
#extension GL_EXT_geometry_shader4: enable
layout(triangles) in;
layout(triangle_strip, max_vertices=200) out;

uniform float uShrink;

in vec3 vNormal[3];
in vec2 vST[3];

out float gLightIntensity;
out vec2 textCoords;

const vec3 LIGHTPOS = vec3(0., 10., 0.);  // Light position from the slides
vec3 CG;

void ProduceVertex(int index) {
    vec3 vertexTransform = CG + uShrink * (gl_in[index].gl_Position.xyz - CG);

    // Calculating the light intensity at the adjusted position
    vec3 normal = normalize(vNormal[index]);
    vec3 lightDir = normalize(LIGHTPOS - vertexTransform);
    gLightIntensity = dot(lightDir, normal);
    gLightIntensity = abs(gLightIntensity);

    // Passing the texture coordinates to the fragment shader
    textCoords = vST[index];

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * vec4(vertexTransform, 1.0);
    EmitVertex();
}

void main() {
    vec3 V[3];
    V[0] = gl_in[0].gl_Position.xyz;
    V[1] = gl_in[1].gl_Position.xyz;
    V[2] = gl_in[2].gl_Position.xyz;
    
    CG = (V[0] + V[1] + V[2]) / 3.0;

    ProduceVertex(0);
    ProduceVertex(1);
    ProduceVertex(2);
}
