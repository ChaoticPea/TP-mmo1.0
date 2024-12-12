Shader "Unlit/NewUnlitShader"
{
   Properties 
   {
    //面板参数
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
    _gloss( "高光范围" , Range(1, 256.0)) = 1
    _glossStrength( "高光强度" , Range(0.0, 1.0)) = 1
    _metalMapColor( "金属反射颜色" , color) = (1.0, 1.0, 1.0, 1.0)
    [Space(30.0)]
    
    _outline( "描边粗细" , Range(0.0, 1.0)) = 0.4
    _outlineColor0( "描边颜色1" , color) = (1.0, 0.0, 0.0, 0.0)
    _outlineColor1( "描边颜色2" , color) = (0.0, 1.0, 0.0, 0.0)
    _outlineColor2( "描边颜色3" , color) = (0.0, 0.0, 1.0, 0.0)
    _outlineColor3( "描边颜色4" , color) = (1.0, 1.0, 0.0, 0.0)
    _outlineColor4( "描边颜色5" , color) = (0.5, 0.0, 1.0, 0.0)
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
//导入库
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"  //默认库
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"  //光照库
CBUFFER_START(UnityPerMaterial)  //常量缓冲区开头
    //声明面板参数
    float _genshinShader;  //是否是脸部
    //diffuse
    float _fresnel;  //边缘光范围
    float _edgeLight;  //边缘光强度
    float _diffuseA;  //diffuseA
    float _Cutoff;  //透明阈值
    float4 _glow;  //自发光强度
    float _flicker;  //发光闪烁速度
    //lightmap/FaceLightmap
    float _bright;  //亮面范围
    float _grey;  //灰面范围
    float _dark;  //暗面范围
    //normal
    float _bumpScale;  //法线强度
    //ramp
    float _dayAndNight;  //是否是白天
    float _lightmapA0;  //1.0_Ramp条数
    float _lightmapA1;  //0.7_Ramp条数
    float _lightmapA2;  //0.5_Ramp条数
    float _lightmapA3;  //0.3_Ramp条数
    float _lightmapA4;  //0.0_Ramp条数
    //高光
    float _gloss;  //高光范围
    float _glossStrength;  //高光强度
    float3 _metalMapColor;  //金属反射颜色
    //描边
    float _outline;  //描边粗细
    float3 _outlineColor0;  //描边颜色1
    float3 _outlineColor1;  //描边颜色2
    float3 _outlineColor2;  //描边颜色3
    float3 _outlineColor3;  //描边颜色4
    float3 _outlineColor4;  //描边颜色5
CBUFFER_END  //常量缓冲区结尾
    //声明贴图
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

    //输入结构
    struct a2v {
    float4 vertex : POSITION;  //获取顶点数据
    float2 texcoord0 : TEXCOORD0;  //获取uv0
    float3 normal : NORMAL;  //获取顶点法线
    float4 tangent : TANGENT;  //获取顶点切线
    };

    //输出结构
    struct v2f {
    float4 pos : SV_POSITION;  //顶点数据
    float2 uv0 : TEXCOORD0;  //uv0
    //矩阵
    float4 TtoW0 : TEXCOORD1;  //x切线,y副切线,z法线,w顶点
    float4 TtoW1 : TEXCOORD2;  //x切线,y副切线,z法线,w顶点
    float4 TtoW2 : TEXCOORD3;  //x切线,y副切线,z法线,w顶点
    };

    //ramp
float3 shadow_ramp(float4 lightmap, float NdotL){
    lightmap.g = smoothstep(0.2, 0.3, lightmap.g);  //lightmap.g
    float halfLambert = smoothstep(0.0, _grey, NdotL + _dark) * lightmap.g;  //半Lambert
    float brightMask = step(_bright, halfLambert);  //亮面
    //判断白天与夜晚
    float rampSampling = 0.0;
    if(_dayAndNight == 0){rampSampling = 0.5;}
    //计算ramp采样条数
    float ramp0 = _lightmapA0 * -0.1 + 1.05 - rampSampling;  //0.95
    float ramp1 = _lightmapA1 * -0.1 + 1.05 - rampSampling;  //0.65
    float ramp2 = _lightmapA2 * -0.1 + 1.05 - rampSampling;  //0.75
    float ramp3 = _lightmapA3 * -0.1 + 1.05 - rampSampling;  //0.55
    float ramp4 = _lightmapA4 * -0.1 + 1.05 - rampSampling;  //0.45
    //分离lightmap.a各材质
    float lightmapA2 = step(0.25, lightmap.a);  //0.3
    float lightmapA3 = step(0.45, lightmap.a);  //0.5
    float lightmapA4 = step(0.65, lightmap.a);  //0.7
    float lightmapA5 = step(0.95, lightmap.a);  //1.0
    //重组lightmap.a
    float rampV = ramp0;  //0.0
    rampV = lerp(rampV, ramp1, lightmapA2);  //0.3
    rampV = lerp(rampV, ramp2, lightmapA3);  //0.5
    rampV = lerp(rampV, ramp3, lightmapA4);  //0.7
    rampV = lerp(rampV, ramp4, lightmapA5);  //1.0
    //采样ramp
    float3 ramp = SAMPLE_TEXTURE2D(_ramp, sampler_ramp, float2(halfLambert, rampV)); 
    float3 shadowRamp = lerp(ramp, halfLambert, brightMask);  //遮罩亮面
    return shadowRamp;  //输出结果
}

//高光
float3 Spec(float NdotL, float NdotH, float3 nDirVS, float4 lightmap, float3 baseColor){
    float blinnPhong = pow(max(0.0, NdotH), _gloss);  //Blinn-Phong
    float3 specular = blinnPhong * lightmap.r * _glossStrength;  //高光强度
    specular = specular * lightmap.b;  //混合高光细节
    specular = baseColor * specular;  //叠加固有色
    lightmap.g = smoothstep(0.2, 0.3, lightmap.g);  //lightmap.g
    float halfLambert = smoothstep(0.0, _grey, NdotL + _dark) * lightmap.g;  //半Lambert
    float brightMask = step(_bright, halfLambert);  //亮面
    specular = specular * brightMask;  //遮罩暗面
    return specular;  //输出结果
}

//金属
float3 Metal(float3 nDirVS, float4 lightmap, float3 baseColor){
    float metalMask = 1 - step(lightmap.r, 0.9);  //金属遮罩
    //采样metalMap
    float3 metalMap = SAMPLE_TEXTURE2D(_metalMap, sampler_metalMap, nDirVS.rg * 0.5 + 0.5).r;
    metalMap = lerp(_metalMapColor, baseColor, metalMap);  //金属反射颜色
    metalMap = lerp(0.0, metalMap, metalMask);  //遮罩非金属区域
    return metalMap;  //输出结果
}

//边缘光
float3 edgeLight(float NdotV, float3 baseColor){
    float3 fresnel = pow(1 - NdotV, _fresnel);  //菲涅尔范围
    fresnel = step(0.5, fresnel) * _edgeLight * baseColor;  //边缘光强度
    return fresnel;  //输出结果
}

//自发光
float3 light(float3 baseColor, float diffsueA){
    diffsueA = smoothstep(0.0, 1.0, diffsueA);  //去除噪点
    float3 glow = lerp(0.0, baseColor * ((sin(_Time.w * _flicker) * 0.5 + 0.5) * _glow), diffsueA);  //自发光
    return glow;  //输出结果
}

//身体
float3 Body(float NdotL, float NdotH, float NdotV, float4 lightmap, float3 baseColor, float3 nDirVS){
    float3 ramp = shadow_ramp(lightmap, NdotL);  //ramp
    float3 specular = Spec(NdotL, NdotH, nDirVS, lightmap, baseColor);  //高光
    float3 metal = Metal(nDirVS, lightmap, baseColor);  //金属
    float3 diffsue = baseColor * ramp;  //漫反射
    diffsue = diffsue * step(lightmap.r, 0.9);  //遮罩金属区域
    float3 fresnel = edgeLight(NdotV, baseColor);  //边缘光
    //混合最终结果
    float3 body = diffsue + metal + specular + fresnel;
    return body;  //输出结果
}

//脸部
float3 Face(float3 lDirWS, float3 baseColor, float2 uv){ 
    //采样贴图
    float SDF = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, uv).r;  //采样SDF
    float SDF2 = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, float2(1-uv.x, uv.y)).r;  //翻转x轴采样SDF
    //计算向量
    float3 up = float3(0,1,0);  //上方向
    float3 front = unity_ObjectToWorld._13_23_33;  //角色前朝向
    float3 left = cross(front, up);  //左侧朝向
    float3 right = -cross(front, up);  //右侧朝向
    //点乘向量
    float frontL = dot(normalize(front.xz), normalize(lDirWS.xz));  //前点乘光
    float leftL = dot(normalize(left.xz), normalize(lDirWS.xz));  //左点乘光
    float rightL = dot(normalize(right.xz), normalize(lDirWS.xz));  //右点乘光
    //计算阴影
    float lightAttenuation = (frontL > 0) * min((SDF > leftL), 1 - (SDF2 < rightL));
    //判断白天与夜晚
    float rampSampling = 0.0;
    if(_dayAndNight == 0){rampSampling = 0.5;}
    //计算V轴
    float rampV = _lightmapA4 * -0.1 + 1.05 - rampSampling;  //0.85
    //采样ramp
    float3 rampColor = SAMPLE_TEXTURE2D(_ramp, sampler_ramp, float2(lightAttenuation, rampV));
    //混合baseColor
    float3 face = lerp(baseColor * rampColor, baseColor, lightAttenuation);
    return face;  //输出结果
}

    //顶点Shader
    v2f vert (a2v v) {
    v2f o;  //定义返回值
    o.pos = TransformObjectToHClip(v.vertex.xyz);  //MVP变换(模型空间>>世界空间>>视觉空间>>裁剪空间)
    o.uv0 = v.texcoord0;  //传递uv0(无变换)
    float3 nDirWS = TransformObjectToWorldNormal(v.normal);  //世界空间法线
    float3 tDirWS = TransformObjectToWorld(v.tangent.xyz);  //世界空间切线
    float3 bDirWS = cross(nDirWS, tDirWS) * v.tangent.w;  //世界空间副切线
    float3 posWS = TransformObjectToWorld(v.vertex.xyz);  //世界顶点位置
    //构建矩阵
    o.TtoW0 = float4(tDirWS.x, bDirWS.x, nDirWS.x, posWS.x);  //x切线,y副切线,z法线,w顶点
    o.TtoW1 = float4(tDirWS.y, bDirWS.y, nDirWS.y, posWS.y);  //x切线,y副切线,z法线,w顶点
    o.TtoW2 = float4(tDirWS.z, bDirWS.z, nDirWS.z, posWS.z);  //x切线,y副切线,z法线,w顶点
    return o;  //返回顶点Shader
    }

    //片元Shader
    half4 frag (v2f i) : SV_TARGET {
    //采样贴图
    float3 baseColor = SAMPLE_TEXTURE2D(_diffuse, sampler_diffuse, i.uv0).rgb;  //diffuseRGB通道
    float diffuseA = SAMPLE_TEXTURE2D(_diffuse,sampler_diffuse, i.uv0).a;  //diffuseA通道
    float4 lightmap = SAMPLE_TEXTURE2D(_lightmap, sampler_lightmap, i.uv0).rgba;  //lightmap
    //法线贴图
    float3 nDirTS = UnpackNormal(SAMPLE_TEXTURE2D(_bumpMap, sampler_bumpMap, i.uv0)).rgb;  //切线空间法线(采样法线贴图并解码)
    nDirTS.xy *= _bumpScale;  //法线强度
    nDirTS.z = sqrt(1.0 - saturate(dot(nDirTS.xy, nDirTS.xy)));  //计算法线z分量
    //准备向量
    float3 posWS = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);  //世界空间顶点
    //切线空间法线转世界空间法线
    float3 nDirWS = normalize(half3(dot(i.TtoW0.xyz, nDirTS), dot(i.TtoW1.xyz, nDirTS), dot(i.TtoW2.xyz, nDirTS)));
    Light mlight = GetMainLight();  //光源
    float3 lDirWS= normalize(mlight.direction);  //世界光源方向(平行光)
    float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - posWS.xyz);  //世界观察方向
    float3 nDirVS = normalize(mul((float3x3)UNITY_MATRIX_V, nDirWS));  //世界空间法线转观察空间法线
    float3 hDirWS = normalize(vDirWS + lDirWS) ;  //半角方向
    //向量点乘
    float NdotL = dot(nDirWS, lDirWS);  //兰伯特
    float NdotH = dot(nDirWS, hDirWS);  //Blinn-Phong
    float NdotV = dot(nDirWS, vDirWS);  //菲涅尔

    //主体渲染
    float3 col = float3(0.0, 0.0, 0.0);
    if(_genshinShader == 0.0){  //身体
    col = Body(NdotL, NdotH, NdotV, lightmap, baseColor, nDirVS);
    }else if(_genshinShader == 1.0){  //脸部
    col = Face(lDirWS, baseColor, i.uv0);
    }
    return half4(col, 1.0);  //输出
    }

            ENDHLSL
         }
    }


}
