#ifndef MAINLIGHT_INCLUDED
#define MAINLIGHT_INCLUDED

void GetMainLight_float(out half3 color, out half3 direction, out half attenuation)
{
    #ifdef SHADERGRAPH_PREVIEW
    direction = half3(0.5, 0.5, 0.5); // default light direction
    color = half3(1, 1, 1); // white color
    attenuation = 1.0;
    #else

    // URP
    #if defined(UNIVERSAL_LIGHTING_INCLUDED)
    
    // GetMainLight from Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
    Light mainLight = GetMainLight();
    color = mainLight.color;
    direction = mainLight.direction;
    attenuation = mainLight.distanceAttenuation * mainLight.shadowAttenuation;

    #endif
    #endif
}

#endif