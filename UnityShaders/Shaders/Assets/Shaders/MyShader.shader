Shader "MyShader"
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
			
			fixed4 MyColor;
			sampler2D MyTexture; //Here, in CG language, the texture type is sampler2D.
			
			// Unity fills this structure in before it passes it to the vertex shader ( myVertex )
			struct appdata
			{
				float4 vertex : POSITION;
				float2 textureCoordinates : TEXCOORD0;
			};
			
			struct vectorToFragment
			{
				float4 position : SV_POSITION;
				float2 textureCoordinates : TEXCOORD0;
			};
			
			vectorToFragment myVertex(appdata IN)
			{
				vectorToFragment OUT;
				OUT.position = mul(UNITY_MATRIX_MVP,IN.vertex);
				OUT.textureCoordinates = IN.textureCoordinates;
				return OUT;
			}
			
			fixed4 myFragment(vectorToFragment IN) : COLOR
			{
				fixed4 textureColor = tex2D(MyTexture,IN.textureCoordinates);
				return textureColor;
			}
			
			ENDCG
		}
	}
}