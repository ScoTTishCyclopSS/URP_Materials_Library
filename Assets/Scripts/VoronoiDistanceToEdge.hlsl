#ifndef MY_HLSL_INCLUDE
#define MY_HLSL_INCLUDE

// https://iquilezles.org/articles/voronoilines/


// based on Unity
inline float2 voronoi_noise_randomVector(float2 UV, float offset)
{
    float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
}

// based on Unity
void DisToEdge_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
{
    float2 g = floor(UV * CellDensity);
    float2 f = frac(UV * CellDensity);
    float3 res = float3(8.0, 8.0, 0.0);

    float2 m_lattice;
    float2 m_v;

    // Unity Voronoi
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            float2 lattice = float2(x, y);
            float2 offset = voronoi_noise_randomVector(lattice + g, AngleOffset);
            float2 v = lattice + offset - f;

            float d = dot(v, v); // faster

            if (d < res.x)
            {
                res = float3(d, offset.x, offset.y);
                Out = res.x;
                Cells = res.y;

                m_lattice = lattice; // lattice for next iteration
                m_v = v;
            }
        }
    }

    // "the solution must be to first detect which cell contains the closest point to our shading point x,
    // then do the neighbor search centered at that cell instead of the cell that contains x"

    // 2nd cycle 
    res = float3(8.0, 8.0, 0.0);
    for (int y = -2; y <= 2; y++)
    {
        for (int x = -2; x <= 2; x++)
        {
            float2 lattice = float2(x, y) + m_lattice; // + m_lattice
            float2 offset = voronoi_noise_randomVector(lattice + g, AngleOffset);
            float2 v = lattice + offset - f;

            float d = dot(0.5 * (m_v + v), normalize(v - m_v));
            res = min(res, d);
        }
    }

    Out = res.x;
}
#endif
