#version 330 compatibility

in vec3 vMCposition;        // Vertex position in camera
in vec3 vNormal;            // Normal vector in camera
in vec2 textCoords;         // Texture coordinates
in float gLightIntensity;   // Light intensity

uniform float uTime;            // Parameter for changing the color of the ice dragon
uniform float uSpectre;         // Parameter for adjusting the transparency of the ice dragon
uniform float uIcyGlow;         // Parameter for creating a glass-like glowing effect for the ice dragon

uniform sampler2D texture1;
uniform vec3 lightPosition;

// Colors for the ice effect and breath effect
const vec3 iceColor = vec3(0.5, 0.8, 1.0);          // Base ice color
const vec3 breathColor = vec3(0.2, 0.4, 0.8);       // Breath effect color

void main() {
    // Adjusting the normals, vertex position, and light direction
    vec3 Normal = normalize(vNormal);
    vec3 LightDir = normalize(lightPosition - vMCposition);
    vec3 ReflectDir = reflect(-LightDir, Normal);

    // Applying the specular highlight calculation
    float specAngle = max(dot(ReflectDir, Normal), 0.0);
    float shineFactor = pow(specAngle, 128.0);

    // Improving the dynamic effect using uTime for color change animation
    float dynamicEffect = 0.5 + 0.5 * sin(uTime * 3.14159265);

    // Interpolating between the ice and breath colors with dynamic effect
    vec3 dynamicColor = mix(iceColor, breathColor, dynamicEffect);

    // Combining the dynamic color with specular highlight, with gLightIntensity
    vec3 color = (dynamicColor + vec3(shineFactor)) * gLightIntensity;

    // Applying the Icy Glow Effect
    vec3 icyGlowColor = vec3(uIcyGlow) * vec3(0.2, 0.4, 0.8);   // Glass like color suits for ice dragon
    vec3 finalColor = mix(color, icyGlowColor, uIcyGlow);

    vec4 texColor = texture(texture1, textCoords);

    // Applying the final color with spectre transparency
    gl_FragColor = vec4(finalColor * texColor.rgb, uSpectre);
}
