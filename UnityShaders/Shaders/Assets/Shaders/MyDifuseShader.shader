Shader "MyDiffuseShader"
{
	Properties
	{
		MyColor ("Shader Color",Color) = (1,1,1,1)
		MyTexture ("Shader Texture", 2D) = "white"{} //Here, in ShaderLab language, the texture type is 2D
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex myVertex
			#pragma fragment myFragment
			
			float4 _LightColor0; // This variable is filled by Unity
			
			fixed4 MyColor;
			sampler2D MyTexture; //Here, in CG language, the texture type is sampler2D.
			
			// Unity fills this structure in before it passes it to the vertex shader ( myVertex )
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL; // Unity will fill in the normal of this vertex
				float2 textureCoordinates : TEXCOORD0;
			};
			
			// This is a structure we fill using the code below and give to Unity.
			struct vectorToFragment
			{
				float4 position : SV_POSITION;
				float3 normal : NORMAL;
				float2 textureCoordinates : TEXCOORD0;
			};
			
			// This is how we modify vectorToFragment type objects using the appdata type object given to us by Unity.
			vectorToFragment myVertex(appdata IN)
			{
				vectorToFragment OUT;
				OUT.position = mul(UNITY_MATRIX_MVP,IN.vertex);
				float4 normalAsFloat4 = float4(IN.normal,0.0); // We created a new float4 ( 4x4 matrix ) by adding 0.0 to the existing values ( IN.normal )
				float4 normalInWorldSpace = mul(normalAsFloat4,_Object2World); // Object2World is a 4x4 matrix ( float4 ) provided by Unity that transforms object positions in world positions
				OUT.normal = normalInWorldSpace.xyz; // normal is a float3. Thus, we are interested only in the x,y and z values. We don't care about w, the 4th value.
				OUT.textureCoordinates = IN.textureCoordinates;
				return OUT;
			}
			
			fixed4 myFragment(vectorToFragment IN) : COLOR
			{
				fixed4 textureColor = tex2D(MyTexture,IN.textureCoordinates);
				float3 normalDirection = normalize(IN.normal);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuse = _LightColor0.rbg * max(0.0,dot(normalDirection,lightDirection)); //_LightColor0 is the color of the first light. If the product of the normal and light direction is positive, it means we are facing the object.
				
				return MyColor * textureColor * float4(diffuse,1.0);
			}
			
			ENDCG
		}
	}
}