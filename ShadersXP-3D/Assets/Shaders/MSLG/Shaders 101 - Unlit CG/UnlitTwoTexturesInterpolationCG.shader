Shader "Custom/MSLG - Shaders101/Unlit (CG)/Unlit Two Textures Interpolation (CG)"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Tex2("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1) 
        _Tween("Tween", Range(0, 1)) = 0

        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
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

            CGPROGRAM
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

            CBUFFER_START(UnityPerMaterial)
                sampler2D _Tex2;
                float4 _Tex2_ST;

                fixed _Tween;
            CBUFFER_END

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * (1 - _Tween) * _Color;
                col += tex2D(_Tex2, i.uv) * _Tween * _Color;

                return col;
            }
            ENDCG
        }
    }
}
