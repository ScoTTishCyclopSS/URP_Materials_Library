#ifndef WIREFRAME_INCLUDED
#define WIREFRAME_INCLUDED

void ShowWireframe_float(half3 worldPos, half3 worldNormal, out float OutWireframe)
{
    // calculate the dot product between the world normal and the world position
    float dotProduct = dot(worldNormal, worldPos);

    // if the dot product is negative, we are on the backside of the polygon, so set the output to 0
    if (dotProduct < 0)
    {
        OutWireframe = 0;
    }
    else
    {
        // otherwise, we are on the front side of the polygon, so set the output to 1
        
        OutWireframe = 1;
        
        // calculate the cross product between the world normal and each axis
        float3 crossX = cross(worldNormal, float3(1,0,0));
        float3 crossY = cross(worldNormal, float3(0,1,0));
        float3 crossZ = cross(worldNormal, float3(0,0,1));

        // calculate the lengths of each cross product
        float lenX = length(crossX);
        float lenY = length(crossY);
        float lenZ = length(crossZ);

        // if any two cross products have a length close to zero, we are diagonal to the polygon, so set the output to 0
        if (lenX < 0.01 && lenY < 0.01 ||
            lenX < 0.01 && lenZ < 0.01 ||
            lenY < 0.01 && lenZ < 0.01)
        {
            OutWireframe = 0;
        }
    }
}


#endif
