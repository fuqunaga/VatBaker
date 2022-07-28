Shader "VatBaker/VatSurfaceStandard"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _NormalTex("NormalTex", 2D) = "white" {}
        _AnimationTimeOffset("AnimationTimeOffset", float) = 0.0
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

        UNITY_INSTANCING_BUFFER_START(Props)
           UNITY_DEFINE_INSTANCED_PROP(float, _AnimationTimeOffset)
        UNITY_INSTANCING_BUFFER_END(Props)
        
        void vert (inout appdata v)
        {
            UNITY_SETUP_INSTANCE_ID(v);
            
            float animationTime = CalcVatAnimationTime(_Time.y + UNITY_ACCESS_INSTANCED_PROP(Props, _AnimationTimeOffset));
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