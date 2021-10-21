Shader "Custom/MSLG - Shaders 101/Surface (HLSL)/Surface Two Textures Interpolation (HLSL)"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Tex2("Texture", 2D) = "white" {}

        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0
        _Color("Color", Color) = (1, 1, 1, 1) 
        _Tween("Tween", Range(0, 1)) = 0

        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend", Float) = 0
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
        }

        Blend [_SrcBlend] [_DstBlend]

        HLSLPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Tex2;
        half _Glossiness;
        half _Metallic;
        float4 _Color;
        half _Tween;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Tex2;
        };

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex) * (1 - _Tween) * _Color;
            col += tex2D(_Tex2, IN.uv_Tex2) * _Tween * _Color;

            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = col.a;
        }

        ENDHLSL
    }
    FallBack "Diffuse"
}
