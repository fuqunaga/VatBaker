#ifndef GA_FUQUNA_VATBAKER_VAT_INCLUDED
#define GA_FUQUNA_VATBAKER_VAT_INCLUDED

sampler2D _VatPositionTex;
float4 _VatPositionTex_TexelSize; // (1.0/width, 1.0/height, width, height) // https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html

sampler2D _VatNormalTex;
float4 _VatNormalTex_TexelSize; // (1.0/width, 1.0/height, width, height) // https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html

float _VatAnimFps;
float _VatAnimLength;


inline float CalcVatAnimationTime(float time)
{
    return (time  % _VatAnimLength) * _VatAnimFps;
}

inline float4 CalcVatTexCoord(uint vertexId, float animationTime)
{
    float x = vertexId + 0.5;
    float y = animationTime + 0.5;
    
    return float4(x, y, 0, 0) * _VatPositionTex_TexelSize;   
}

inline float3 GetVatPosition(uint vertexId, float animationTime)
{
    return (float3)tex2Dlod(_VatPositionTex, CalcVatTexCoord(vertexId, animationTime));
}

inline float3 GetVatNormal(uint vertexId, float animationTime)
{
    return (float3)tex2Dlod(_VatNormalTex, CalcVatTexCoord(vertexId, animationTime));
}

#endif