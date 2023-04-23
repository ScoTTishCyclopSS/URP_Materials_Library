#ifndef MY_HLSL_INCLUDE
#define MY_HLSL_INCLUDE

#define FLOORFRAC(x, x_int, x_fract) { float x_floor = floor(x); x_int = int(x_floor); x_fract = x - x_floor; }

// reference: https://github.com/jesterKing/blender/blob/master/blender/intern/cycles/kernel/shaders/node_musgrave_texture.osl
// https://github.com/jesterKing/blender/blob/143ccc8c44cbd1a630c4f02d8c6eb26e26c63757/blender/intern/cycles/kernel/svm/svm_noise.h

float fade(float t)
{
    return t * t * t * (t * (t * 6.0f - 15.0f) + 10.0f);
}

float nerp(float t, float a, float b)
{
    return (1.0f - t) * a + t * b;
}

float grad(int hash, float x, float y, float z)
{
    // use vectors pointing to the edges of the cube
    int h = hash & 15;
    float u = h < 8 ? x : y;
    float v = h < 4 ? y : h == 12 || h == 14 ? x : z;
    return ((h & 1) ? -u : u) + ((h & 2) ? -v : v);
}

uint hash(uint kx, uint ky, uint kz)
{
    // define some handy macros
    #define rot(x,k) (((x)<<(k)) | ((x)>>(32-(k))))
    #define final(a,b,c) \
        { \
        c ^= b; c -= rot(b,14); \
        a ^= c; a -= rot(c,11); \
        b ^= a; b -= rot(a,25); \
        c ^= b; c -= rot(b,16); \
        a ^= c; a -= rot(c,4);  \
        b ^= a; b -= rot(a,14); \
        c ^= b; c -= rot(b,24); \
        }
    // now hash the data!
    uint a, b, c, len = 3;
    a = b = c = 0xdeadbeef + (len << 2) + 13;

    c += kz;
    b += ky;
    a += kx;
    final(a, b, c);

    return c;
    // macros not needed anymore
    #undef rot
    #undef final
}

float scale3(float result)
{
    return 0.9820f * result;
}

float perlin_noise(float3 vec)
{
    int X, Y, Z;
    float fx, fy, fz;

    FLOORFRAC(vec.x, X, fx);
    FLOORFRAC(vec.y, Y, fy);
    FLOORFRAC(vec.z, Z, fz);

    float u = fade(fx);
    float v = fade(fy);
    float w = fade(fz);

    float result;

    result = nerp(w, nerp(v, nerp(u, grad(hash(X, Y, Z), fx, fy, fz), grad(
                                      hash(X + 1, Y, Z), fx - 1.0f, fy, fz)),
                          nerp(u, grad(hash(X, Y + 1, Z), fx, fy - 1.0f, fz),
                               grad(hash(X + 1, Y + 1, Z), fx - 1.0f, fy - 1.0f, fz))),
                  nerp(v, nerp(u, grad(hash(X, Y, Z + 1), fx, fy, fz - 1.0f),
                               grad(hash(X + 1, Y, Z + 1), fx - 1.0f, fy, fz - 1.0f)),
                       nerp(u, grad(hash(X, Y + 1, Z + 1), fx, fy - 1.0f, fz - 1.0f),
                            grad(hash(X + 1, Y + 1, Z + 1), fx - 1.0f, fy - 1.0f, fz - 1.0f))));

    float r = scale3(result);
    return (isfinite(r)) ? r : 0.0f;
}


float safe_noise(float3 p)
{
    float f = perlin_noise(p);

    if (!isfinite(f))
        return 0.5;

    return f;
}


void MusgraveFbm_float(float3 p, float scale, float detail, float dimension, float lacunarity, out float fac)
{

    p = p * scale;
    float H = max(dimension, 1e-5);
    float octaves = clamp(detail, 0.0, 16.0);
    float lac = max(lacunarity, 1e-5);
    
    float value = 0.0;
    float pwr = 1.0;
    float pwHL = pow(lac, -H);

    for (int i = 0; i < int(octaves); i++) {
        value += safe_noise(p) * pwr;
        pwr *= pwHL;
        p *= lac;
    }

    float rmd = octaves - floor(octaves);
    if (rmd != 0.0) {
        value += rmd * safe_noise(p) * pwr;
    }

    fac = value;
}

#endif