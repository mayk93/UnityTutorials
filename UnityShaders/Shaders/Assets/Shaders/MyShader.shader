Shader "MyShader"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex myVertex
			#pragma fragment myFragment
			
			struct appdata
			{
				float4 vertex : POSITION;
			};
			
			struct vectorToFragment
			{
				float4 position : SV_POSITION;
			};
			
			vectorToFragment myVertex(appdata IN)
			{
				vectorToFragment OUT;
				OUT.position = mul(UNITY_MATRIX_MVP,IN.vertex);
				return OUT;
			}
			
			fixed4 myFragment(vectorToFragment IN) : COLOR
			{
				return fixed4(1,0,0,1);
			}
			
			ENDCG
		}
	}
}