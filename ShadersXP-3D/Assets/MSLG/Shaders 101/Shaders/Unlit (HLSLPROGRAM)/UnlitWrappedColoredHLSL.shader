Shader "Custom/MSLG - Shaders101/Unlit (HLSL)/Unlit Wrapped Colored (HLSL)"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _WrapIter("Number of Wraps", Int) = 0
        _Color("Color", Color) = (1, 1, 1, 1)

        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend", Float) = 0
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
        }

        Pass
        {
            Blend [_SrcBlend] [_DstBlend]

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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

            float4 _Color;
            
            CBUFFER_START(UnityPerMaterial)
                int _WrapIter;
            CBUFFER_END
            

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                if(_WrapIter > 0) {
                    o.uv = _WrapIter * v.uv;
                }
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * (float4(i.uv.r/ _WrapIter, i.uv.g/ _WrapIter, 1, 1) );
                return col;
            }
            ENDHLSL
        }
    }
}
