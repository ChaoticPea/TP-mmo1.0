Shader "Unlit/NewUnlitShader"
{
   Properties 
   {
    //������
    [Space(20.0)]
    [Toggle]_genshinShader( "Is Face? (face/eye/mouth)" , float) = 0.0

    [Space(15.0)]
    [NoScaleOffset]_diffuse( "Diffuse" , 2d) = "white"{}
    _fresnel( "Edge light range" , Range(0.0, 10.0)) = 1.7
    _edgeLight( "Edge light intensity" , Range(0.0, 1.0)) = 0.02
    [Space(8.0)]
    _diffuseA( "Alpha(1 transparent, 2 self luminous)" , Range(0.0, 2.0)) = 0
    _Cutoff( "Transparent threshold" , Range(0.0, 1.0)) = 1.0
    [HDR]_glow( "Self luminous intensity" , color) = (1.0, 1.0, 1.0, 1.0)
    _flicker( "Luminous flashing speed" , float) = 0.8
    [Space(30.0)]

    [NoScaleOffset]_lightmap( "Lightmap/FaceLightmap" , 2d) = "white"{}
    _bright( "Bright surface range" , float) = 0.99
    _grey( "Gray surface range" , float) = 1.14
    _dark( "Dark surface range" , float) = 0.5
    [Space(30.0)]

    [NoScaleOffset]_bumpMap( "Normalmap" , 2d) = "bump"{}
    _bumpScale( "Normal intensity" , float) = 1.0
    [Space(30.0)]

    [NoScaleOffset]_ramp( "Shadow_Ramp" , 2d) = "white"{}
    [Toggle]_dayAndNight("Is it daytime" , float) = 0.0
    [Space(8.0)]
    _lightmapA0("1.0_Ramp" , Range(1, 5)) = 1
    _lightmapA1("0.7_Ramp" , Range(1, 5)) = 4
    _lightmapA2("0.5_Ramp" , Range(1, 5)) = 3
    _lightmapA3("0.3_Ramp" , Range(1, 5)) = 5
    _lightmapA4("0.0_Ramp" , Range(1, 5)) = 2
    [Space(30.0)]

    [NoScaleOffset]_metalMap( "MetalMap" , 2d) = "white"{}
    _gloss( "�߹ⷶΧ" , Range(1, 256.0)) = 1
    _glossStrength( "�߹�ǿ��" , Range(0.0, 1.0)) = 1
    _metalMapColor( "����������ɫ" , color) = (1.0, 1.0, 1.0, 1.0)
    [Space(30.0)]
    
    _outline( "��ߴ�ϸ" , Range(0.0, 1.0)) = 0.4
    _outlineColor0( "�����ɫ1" , color) = (1.0, 0.0, 0.0, 0.0)
    _outlineColor1( "�����ɫ2" , color) = (0.0, 1.0, 0.0, 0.0)
    _outlineColor2( "�����ɫ3" , color) = (0.0, 0.0, 1.0, 0.0)
    _outlineColor3( "�����ɫ4" , color) = (1.0, 1.0, 0.0, 0.0)
    _outlineColor4( "�����ɫ5" , color) = (0.5, 0.0, 1.0, 0.0)
   }
      
    SubShader
    {
         Tags 
        {
            // SRP introduced a new "RenderPipeline" tag in Subshader. This allows you to create shaders
            // that can match multiple render pipelines. If a RenderPipeline tag is not set it will match
            // any render pipeline. In case you want your SubShader to only run in URP, set the tag to
            // "UniversalPipeline"

            // here "UniversalPipeline" tag is required, because we only want this shader to run in URP.
            // If Universal render pipeline is not set in the graphics settings, this SubShader will fail.

            // One can add a SubShader below or fallback to Standard built-in to make this
            // material works with both Universal Render Pipeline and Builtin-RP

            // the tag value is "UniversalPipeline", not "UniversalRenderPipeline", be careful!
            "RenderPipeline" = "UniversalPipeline"

            // explicit SubShader tag to avoid confusion
            "RenderType" = "Opaque"
            "IgnoreProjector" = "True"
            "UniversalMaterialType" = "ComplexLit"
            "Queue"="Geometry"
        }
        LOD 100
        
HLSLINCLUDE
//�����
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"  //Ĭ�Ͽ�
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"  //���տ�
CBUFFER_START(UnityPerMaterial)  //������������ͷ
    //����������
    float _genshinShader;  //�Ƿ�������
    //diffuse
    float _fresnel;  //��Ե�ⷶΧ
    float _edgeLight;  //��Ե��ǿ��
    float _diffuseA;  //diffuseA
    float _Cutoff;  //͸����ֵ
    float4 _glow;  //�Է���ǿ��
    float _flicker;  //������˸�ٶ�
    //lightmap/FaceLightmap
    float _bright;  //���淶Χ
    float _grey;  //���淶Χ
    float _dark;  //���淶Χ
    //normal
    float _bumpScale;  //����ǿ��
    //ramp
    float _dayAndNight;  //�Ƿ��ǰ���
    float _lightmapA0;  //1.0_Ramp����
    float _lightmapA1;  //0.7_Ramp����
    float _lightmapA2;  //0.5_Ramp����
    float _lightmapA3;  //0.3_Ramp����
    float _lightmapA4;  //0.0_Ramp����
    //�߹�
    float _gloss;  //�߹ⷶΧ
    float _glossStrength;  //�߹�ǿ��
    float3 _metalMapColor;  //����������ɫ
    //���
    float _outline;  //��ߴ�ϸ
    float3 _outlineColor0;  //�����ɫ1
    float3 _outlineColor1;  //�����ɫ2
    float3 _outlineColor2;  //�����ɫ3
    float3 _outlineColor3;  //�����ɫ4
    float3 _outlineColor4;  //�����ɫ5
CBUFFER_END  //������������β
    //������ͼ
    TEXTURE2D(_diffuse);  //Diffuse
    SAMPLER(sampler_diffuse);
    TEXTURE2D(_lightmap);  //Lightmap/FaceLightmap
    SAMPLER(sampler_lightmap);
    TEXTURE2D(_bumpMap);  //Normal
    SAMPLER(sampler_bumpMap);
    TEXTURE2D(_ramp);  //Shadow_Ramp
    SAMPLER(sampler_ramp);
    TEXTURE2D(_metalMap);  //MetalMap
    SAMPLER(sampler_metalMap);
ENDHLSL

        Pass
        {
            Tags { 
            "LightMode" = "head" 
            }
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _FORWARD_PLUS
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"

    //����ṹ
    struct a2v {
    float4 vertex : POSITION;  //��ȡ��������
    float2 texcoord0 : TEXCOORD0;  //��ȡuv0
    float3 normal : NORMAL;  //��ȡ���㷨��
    float4 tangent : TANGENT;  //��ȡ��������
    };

    //����ṹ
    struct v2f {
    float4 pos : SV_POSITION;  //��������
    float2 uv0 : TEXCOORD0;  //uv0
    //����
    float4 TtoW0 : TEXCOORD1;  //x����,y������,z����,w����
    float4 TtoW1 : TEXCOORD2;  //x����,y������,z����,w����
    float4 TtoW2 : TEXCOORD3;  //x����,y������,z����,w����
    };

    //ramp
float3 shadow_ramp(float4 lightmap, float NdotL){
    lightmap.g = smoothstep(0.2, 0.3, lightmap.g);  //lightmap.g
    float halfLambert = smoothstep(0.0, _grey, NdotL + _dark) * lightmap.g;  //��Lambert
    float brightMask = step(_bright, halfLambert);  //����
    //�жϰ�����ҹ��
    float rampSampling = 0.0;
    if(_dayAndNight == 0){rampSampling = 0.5;}
    //����ramp��������
    float ramp0 = _lightmapA0 * -0.1 + 1.05 - rampSampling;  //0.95
    float ramp1 = _lightmapA1 * -0.1 + 1.05 - rampSampling;  //0.65
    float ramp2 = _lightmapA2 * -0.1 + 1.05 - rampSampling;  //0.75
    float ramp3 = _lightmapA3 * -0.1 + 1.05 - rampSampling;  //0.55
    float ramp4 = _lightmapA4 * -0.1 + 1.05 - rampSampling;  //0.45
    //����lightmap.a������
    float lightmapA2 = step(0.25, lightmap.a);  //0.3
    float lightmapA3 = step(0.45, lightmap.a);  //0.5
    float lightmapA4 = step(0.65, lightmap.a);  //0.7
    float lightmapA5 = step(0.95, lightmap.a);  //1.0
    //����lightmap.a
    float rampV = ramp0;  //0.0
    rampV = lerp(rampV, ramp1, lightmapA2);  //0.3
    rampV = lerp(rampV, ramp2, lightmapA3);  //0.5
    rampV = lerp(rampV, ramp3, lightmapA4);  //0.7
    rampV = lerp(rampV, ramp4, lightmapA5);  //1.0
    //����ramp
    float3 ramp = SAMPLE_TEXTURE2D(_ramp, sampler_ramp, float2(halfLambert, rampV)); 
    float3 shadowRamp = lerp(ramp, halfLambert, brightMask);  //��������
    return shadowRamp;  //������
}

//�߹�
float3 Spec(float NdotL, float NdotH, float3 nDirVS, float4 lightmap, float3 baseColor){
    float blinnPhong = pow(max(0.0, NdotH), _gloss);  //Blinn-Phong
    float3 specular = blinnPhong * lightmap.r * _glossStrength;  //�߹�ǿ��
    specular = specular * lightmap.b;  //��ϸ߹�ϸ��
    specular = baseColor * specular;  //���ӹ���ɫ
    lightmap.g = smoothstep(0.2, 0.3, lightmap.g);  //lightmap.g
    float halfLambert = smoothstep(0.0, _grey, NdotL + _dark) * lightmap.g;  //��Lambert
    float brightMask = step(_bright, halfLambert);  //����
    specular = specular * brightMask;  //���ְ���
    return specular;  //������
}

//����
float3 Metal(float3 nDirVS, float4 lightmap, float3 baseColor){
    float metalMask = 1 - step(lightmap.r, 0.9);  //��������
    //����metalMap
    float3 metalMap = SAMPLE_TEXTURE2D(_metalMap, sampler_metalMap, nDirVS.rg * 0.5 + 0.5).r;
    metalMap = lerp(_metalMapColor, baseColor, metalMap);  //����������ɫ
    metalMap = lerp(0.0, metalMap, metalMask);  //���ַǽ�������
    return metalMap;  //������
}

//��Ե��
float3 edgeLight(float NdotV, float3 baseColor){
    float3 fresnel = pow(1 - NdotV, _fresnel);  //��������Χ
    fresnel = step(0.5, fresnel) * _edgeLight * baseColor;  //��Ե��ǿ��
    return fresnel;  //������
}

//�Է���
float3 light(float3 baseColor, float diffsueA){
    diffsueA = smoothstep(0.0, 1.0, diffsueA);  //ȥ�����
    float3 glow = lerp(0.0, baseColor * ((sin(_Time.w * _flicker) * 0.5 + 0.5) * _glow), diffsueA);  //�Է���
    return glow;  //������
}

//����
float3 Body(float NdotL, float NdotH, float NdotV, float4 lightmap, float3 baseColor, float3 nDirVS){
    float3 ramp = shadow_ramp(lightmap, NdotL);  //ramp
    float3 specular = Spec(NdotL, NdotH, nDirVS, lightmap, baseColor);  //�߹�
    float3 metal = Metal(nDirVS, lightmap, baseColor);  //����
    float3 diffsue = baseColor * ramp;  //������
    diffsue = diffsue * step(lightmap.r, 0.9);  //���ֽ�������
    float3 fresnel = edgeLight(NdotV, baseColor);  //��Ե��
    //������ս��
    float3 body = diffsue + metal + specular + fresnel;
    return body;  //������
}

//����
float3 Face(float3 lDirWS, float3 baseColor, float2 uv){ 
    //������ͼ
    float SDF = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, uv).r;  //����SDF
    float SDF2 = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, float2(1-uv.x, uv.y)).r;  //��תx�����SDF
    //��������
    float3 up = float3(0,1,0);  //�Ϸ���
    float3 front = unity_ObjectToWorld._13_23_33;  //��ɫǰ����
    float3 left = cross(front, up);  //��೯��
    float3 right = -cross(front, up);  //�Ҳ೯��
    //�������
    float frontL = dot(normalize(front.xz), normalize(lDirWS.xz));  //ǰ��˹�
    float leftL = dot(normalize(left.xz), normalize(lDirWS.xz));  //���˹�
    float rightL = dot(normalize(right.xz), normalize(lDirWS.xz));  //�ҵ�˹�
    //������Ӱ
    float lightAttenuation = (frontL > 0) * min((SDF > leftL), 1 - (SDF2 < rightL));
    //�жϰ�����ҹ��
    float rampSampling = 0.0;
    if(_dayAndNight == 0){rampSampling = 0.5;}
    //����V��
    float rampV = _lightmapA4 * -0.1 + 1.05 - rampSampling;  //0.85
    //����ramp
    float3 rampColor = SAMPLE_TEXTURE2D(_ramp, sampler_ramp, float2(lightAttenuation, rampV));
    //���baseColor
    float3 face = lerp(baseColor * rampColor, baseColor, lightAttenuation);
    return face;  //������
}

    //����Shader
    v2f vert (a2v v) {
    v2f o;  //���巵��ֵ
    o.pos = TransformObjectToHClip(v.vertex.xyz);  //MVP�任(ģ�Ϳռ�>>����ռ�>>�Ӿ��ռ�>>�ü��ռ�)
    o.uv0 = v.texcoord0;  //����uv0(�ޱ任)
    float3 nDirWS = TransformObjectToWorldNormal(v.normal);  //����ռ䷨��
    float3 tDirWS = TransformObjectToWorld(v.tangent.xyz);  //����ռ�����
    float3 bDirWS = cross(nDirWS, tDirWS) * v.tangent.w;  //����ռ丱����
    float3 posWS = TransformObjectToWorld(v.vertex.xyz);  //���綥��λ��
    //��������
    o.TtoW0 = float4(tDirWS.x, bDirWS.x, nDirWS.x, posWS.x);  //x����,y������,z����,w����
    o.TtoW1 = float4(tDirWS.y, bDirWS.y, nDirWS.y, posWS.y);  //x����,y������,z����,w����
    o.TtoW2 = float4(tDirWS.z, bDirWS.z, nDirWS.z, posWS.z);  //x����,y������,z����,w����
    return o;  //���ض���Shader
    }

    //ƬԪShader
    half4 frag (v2f i) : SV_TARGET {
    //������ͼ
    float3 baseColor = SAMPLE_TEXTURE2D(_diffuse, sampler_diffuse, i.uv0).rgb;  //diffuseRGBͨ��
    float diffuseA = SAMPLE_TEXTURE2D(_diffuse,sampler_diffuse, i.uv0).a;  //diffuseAͨ��
    float4 lightmap = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, i.uv0).rgba;  //lightmap
    //������ͼ
    float3 nDirTS = UnpackNormal(SAMPLE_TEXTURE2D(_bumpMap, sampler_bumpMap, i.uv0)).rgb;  //���߿ռ䷨��(����������ͼ������)
    nDirTS.xy *= _bumpScale;  //����ǿ��
    nDirTS.z = sqrt(1.0 - saturate(dot(nDirTS.xy, nDirTS.xy)));  //���㷨��z����
    //׼������
    float3 posWS = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);  //����ռ䶥��
    //���߿ռ䷨��ת����ռ䷨��
    float3 nDirWS = normalize(half3(dot(i.TtoW0.xyz, nDirTS), dot(i.TtoW1.xyz, nDirTS), dot(i.TtoW2.xyz, nDirTS)));
    Light mlight = GetMainLight();  //��Դ
    float3 lDirWS= normalize(mlight.direction);  //�����Դ����(ƽ�й�)
    float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - posWS.xyz);  //����۲췽��
    float3 nDirVS = normalize(mul((float3x3)UNITY_MATRIX_V, nDirWS));  //����ռ䷨��ת�۲�ռ䷨��
    float3 hDirWS = normalize(vDirWS + lDirWS) ;  //��Ƿ���
    //�������
    float NdotL = dot(nDirWS, lDirWS);  //������
    float NdotH = dot(nDirWS, hDirWS);  //Blinn-Phong
    float NdotV = dot(nDirWS, vDirWS);  //������

    //������Ⱦ
    float3 col = float3(0.0, 0.0, 0.0);
    if(_genshinShader == 0.0){  //����
    col = Body(NdotL, NdotH, NdotV, lightmap, baseColor, nDirVS);
    }else if(_genshinShader == 1.0){  //����
    col = Face(lDirWS, baseColor, i.uv0);
    }
    return half4(col, 1.0);  //���
    }

            ENDHLSL
         }
    }


}
