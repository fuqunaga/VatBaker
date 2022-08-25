Shader "VatBaker/VatUnlit"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _AnimationTimeOffset("AnimationTimeOffset", float) = 0.0
        _VatPositionTex ("VatPositionTex", 2D) = "white" {}
        _VatAnimFps("VatAnimFps", float) = 5.0
        _VatAnimLength("VatAnimLength", float) = 5.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"
            #include "Vat.hlsl"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float, _AnimationTimeOffset)
            UNITY_INSTANCING_BUFFER_END(Props)
        

            v2f_img vert (appdata_img v, uint vId : SV_VertexID)
            {
                UNITY_SETUP_INSTANCE_ID(v);
                
                float animTime = CalcVatAnimationTime(_Time.y + UNITY_ACCESS_INSTANCED_PROP(Props, _AnimationTimeOffset));
                float3 pos = GetVatPosition(vId, animTime);

                v2f_img o;
                UNITY_INITIALIZE_OUTPUT(v2f_img, o);
                o.pos = UnityObjectToClipPos(pos);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}