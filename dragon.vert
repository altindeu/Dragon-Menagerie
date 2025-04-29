#version 330 compatibility

out vec3 vMCposition;
out vec3 vNormal;
out vec2 vST;
out float gLightIntensity; // Light intensity to the fragment shader

const vec3 LIGHTPOS = vec3(0., 10., 0.);  // Light position from the .geom file

void main() {
    vST = gl_MultiTexCoord0.st;
    vNormal = normalize(gl_NormalMatrix * gl_Normal);

    vMCposition = gl_Vertex.xyz;

    // Applying the directional light intensity based on vertex normal and light direction
    vec3 lightDir = normalize(LIGHTPOS - vMCposition);
    gLightIntensity = max(dot(vNormal, lightDir), 0.0);

    gl_Position = gl_Vertex; // Positioning
}
