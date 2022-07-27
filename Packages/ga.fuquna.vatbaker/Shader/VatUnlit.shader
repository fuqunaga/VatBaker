Shader "VatBaker/VatUnlit"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _VatPositionTex ("VatPositionTex", 2D) = "white" {}
        _VatAnimFps("VatAnimFps", float) = 5.0
        _VatAnimLength("VatAnimLength", float) = 5.0
    }
    SubShader
    {
        Tags { "RenderQueue"="Qpaque" "RenderType"="Opaque" }
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Vat.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;


            v2f vert (appdata v, uint vId : SV_VertexID)
            {
                v2f o;

                float animTime = CalcVatAnimationTime(_Time.y);
                float3 pos = GetVatPosition(vId, animTime);
                
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}