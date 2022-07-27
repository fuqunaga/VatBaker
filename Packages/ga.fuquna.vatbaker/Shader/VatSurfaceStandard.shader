Shader "VatBaker/VatSurfaceStandard"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _NormalTex("NormalTex", 2D) = "white" {}
        _VatPositionTex ("VatPositionTex", 2D) = "white" {}
        _VatNormalTex ("VatNormalTex", 2D) = "white" {}
        _VatAnimFps("VatAnimFps", float) = 5.0
        _VatAnimLength("VatAnimLength", float) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard vertex:vert addshadow

        #include "Vat.hlsl"

        struct appdata
        {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float4 texcoord : TEXCOORD0;
            float4 texcoord1 : TEXCOORD1;
            float4 texcoord2 : TEXCOORD2;
            float4 texcoord3 : TEXCOORD3;
            fixed4 color : COLOR;
            UNITY_VERTEX_INPUT_INSTANCE_ID
            uint vId : SV_VertexID;
        };
        
        struct Input
        {
           float2 uv_MainTex;
           float2 uv_NormalTex;
        };

        sampler2D _MainTex;
        sampler2D _NormalTex;

        void vert (inout appdata v)
        {
            float animationTime = CalcVatAnimationTime(_Time.y);
            v.vertex.xyz = GetVatPosition(v.vId, animationTime);
            v.normal.xyz = GetVatNormal(v.vId, animationTime);
        }
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
        }
        
        ENDCG
    }
}