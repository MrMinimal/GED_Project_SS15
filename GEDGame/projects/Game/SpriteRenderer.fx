

struct SpriteVertex
{
	float3 Pos				: POSITION;
	float Radius			: RADIUS;
	uint TexIndex			: TEXTUREINDEX;
};

struct PSVertex
{
	float4	Position		:	SV_Position;
	float2	t				:	TEXCOORD;
	uint	TexIndex		:	TEXTUREINDEX;
};

// INDEX 0: Gatling
// INDEX 1: Plasma
// siehe Game.cpp
Texture2D		g_Tex[2];

matrix g_ViewProjection;
float3 camRight, camUp;

// Rasterizer states
RasterizerState rsCullNone 
{
	CullMode = None;
};

DepthStencilState EnableDepth
{
	DepthEnable = TRUE;
	DepthWriteMask = ZERO;
	DepthFunc = LESS_EQUAL;
};

BlendState NoBlending
{
	AlphaToCoverageEnable = FALSE;
	BlendEnable[0] = FALSE;
};

BlendState AlphaBlending
{
	BlendEnable[0] = TRUE;
	SrcBlend[0] = SRC_ALPHA;
	SrcBlendAlpha[0] = ONE;
	DestBlend[0] = INV_SRC_ALPHA;
	DestBlendAlpha[0] = INV_SRC_ALPHA;
};

SamplerState samLinearClamp
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};


// ShaderCode
void DummyVS(in SpriteVertex input, out SpriteVertex output) {
	output = input;
}


float4 DummyPS(in PSVertex input) : SV_Target0
{
	switch (input.TexIndex) // Index for g_Tex has to be a Constant!!!!!!!!11!!!!!!!11111
	{
		case 0: // Texture 0
			return g_Tex[0].Sample(samLinearClamp, input.t); 
		case 1:
			return g_Tex[1].Sample(samLinearClamp, input.t);
	}
	return float4(1, 0, 1, 1);
}

/*float4 DummyPS(PSVertex pos) : SV_Target0{
	return float4(1.0f, 1.0f, 0.0f, 1.0f);
}*/

[maxvertexcount(4)]
void SpriteGS(point SpriteVertex vertex[1], inout TriangleStream<PSVertex> stream){

	float radius = vertex[0].Radius;
	PSVertex v = (PSVertex)0;
	v.TexIndex = vertex[0].TexIndex;

	//Links Oben
	v.Position = mul(float4(vertex[0].Pos - radius * camRight + radius * camUp, 1.0f), g_ViewProjection);
	v.t = float2(0.0f, 1.0f);
	stream.Append(v);

	//Rechts Oben
	v.Position = mul(float4(vertex[0].Pos + radius * camRight + radius * camUp, 1.0f), g_ViewProjection);
	v.t = float2(1.0f, 1.0f);
	stream.Append(v);

	//Links Unten
	v.Position = mul(float4(vertex[0].Pos - radius * camRight - radius * camUp, 1.0f), g_ViewProjection);
	v.t = float2(0.0f, 0.0f);
	stream.Append(v);

	//Rechts Unten
	v.Position = mul(float4(vertex[0].Pos + radius * camRight - radius * camUp, 1.0f), g_ViewProjection);
	v.t = float2(1.0f, 0.0f);
	stream.Append(v);

}

//--------------------------------------------------------------------------------------
// Techniques
//--------------------------------------------------------------------------------------
technique11 Render
{
	pass P0
	{
		SetVertexShader(CompileShader(vs_4_0, DummyVS()));
		SetGeometryShader(CompileShader(gs_4_0, SpriteGS()));
		SetPixelShader(CompileShader(ps_4_0, DummyPS()));

		SetRasterizerState(rsCullNone);
		SetDepthStencilState(EnableDepth, 0);
		SetBlendState(AlphaBlending, float4(0.0f, 0.0f, 0.0f, 0.0f), 0xFFFFFFFF);
	}
}