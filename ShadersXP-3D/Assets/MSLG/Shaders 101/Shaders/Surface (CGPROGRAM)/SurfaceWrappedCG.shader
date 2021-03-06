Shader "Custom/MSLG - Shaders101/Surface (CG)/Surface Wrapped (CG)"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0
        _WrapIter("Number of Wraps", Int) = 0

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

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:blend 
        #pragma target 3.0

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        int _WrapIter;

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
            fixed4 col;
            if(_WrapIter > 1) 
            {
                col = tex2D(_MainTex, _WrapIter * IN.uv_MainTex) * _Color;
            }
            else 
            {
                col = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            }

            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = col.a;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
