Shader "Custom/MSLG - Shaders 101/Surface (HLSL)/Surface Grayscale Colored (HLSL)"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0

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
        half _Glossiness;
        half _Metallic;
        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex);
            float luminance = 0.3 * col.r + 0.59 * col.g + 0.11 * col.b;

            col *= float4(luminance, luminance, luminance, col.a) * _Color;
            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = col.a;
        }

        ENDHLSL
    }
    FallBack "Diffuse"
}
