// Vertex shader
#version 420

//uniform mat4 MVP;
uniform mat4 matModel;
uniform mat4 matView;
uniform mat4 matProjection;
uniform mat4 matModelInverseTranspose;	// For normal calculation


//uniform bool bUseVertexColour;		// Will default to GL_FALSE, which is zero (0)
//uniform vec3 vertexColourOverride;

in vec4 vColour;
in vec4 vPosition;
in vec4 vNormal;				// Vertex normal X,Y,Z (W ignored)
in vec4 vUVx2;					// 2 x Texture coords (vec4) UV0, UV1
in vec4 vTangent;				// For bump mapping X,Y,Z (W ignored)
in vec4 vBiNormal;				// For bump mapping X,Y,Z (W ignored)


out vec4 fVertexColour;			// used to be "out vec3 color"
out vec4 fVertWorldLocation;
out vec4 fNormal;
out vec4 fUVx2;

// For the height map example
uniform sampler2D heightMapTexture;
uniform bool bUseHeightMap;
uniform vec3 heightMapUVOffsetRotation;
uniform float heightMapScale;



void main()
{
	// Order of these is important
	//mvp = p * v * matModel; from C++ code
	
	mat4 MVP = matProjection * matView * matModel;
	
	vec4 vertPosition = vPosition;
	
	if (bUseHeightMap)
	{

//       _                                                               _      _      _      _  _  _  
//      / \    __ _   __ _   __ _  _ __  _ __  _ __  __ _   __ _   __ _ | |__  | |__  | |__  | || || | 
//     / _ \  / _` | / _` | / _` || '__|| '__|| '__|/ _` | / _` | / _` || '_ \ | '_ \ | '_ \ | || || | 
//    / ___ \| (_| || (_| || (_| || |   | |   | |  | (_| || (_| || (_| || | | || | | || | | ||_||_||_| 
//   /_/   \_\\__,_| \__,_| \__,_||_|   |_|   |_|   \__, | \__, | \__, ||_| |_||_| |_||_| |_|(_)(_)(_) 
//                                                  |___/  |___/  |___/                                
//	So after several hours of thinking "but I've done this maybe 100 times!!! WHY ISN'T THIS WORKING!!!??!?!?!"		
//  I realized something very subtle...
//
//	Below is the original line I had. 
//  Since there was clearly some random (noisy) values being used - the "jumping around" on the surface,
//    I was assuming the binding of the textures wasn't happening (or something like that).
// 
//		vec2 sampleUV = fUVx2.xy + heightMapUVOffset.xy;
//
//  But I was wrong. "fUV..." is the variable LEAVING the vertex shader (as an "out").
//  But at this point in the shader, it isn't SET to anything. So it's random data. 
// 
//  The line should be using "vUV..." (with a "v"), which is ENTERING ("in") the shader. 
// 

		// "Shift" the texture around ("moving" the height map)
		vec2 sampleUV = vUVx2.xy + heightMapUVOffsetRotation.xy;
		
			// Apply a rotation around the centre location:
			float rotationOffset = heightMapUVOffsetRotation.z;
			// We do this in 3 steps:
			// 1. Translate to 0.5,0.5
			// 2. Rotate
			// 3. Translate BACK to 0,0
			//
			// BUUUUUUT, remember that matrix calculations go "backwards", so we 
			//	do these operations in the REVERSE order. 
			// (Another way to think about it, the LAST one you have in code 
			//  is the FIRST operation that happens mathematically.
			//

			// 3: Translate (BACK to the origin):
			sampleUV.xy -= vec2(0.5f, 0.5f);
			
			// 2: Rotate: in 2D. 
			// 
			// See: https://en.wikipedia.org/wiki/Rotation_matrix 
			//      
			//	R = | cos(rotationOffset)   -sin(rotationOffset) |
			//      | sin(rotationOffset)   cos(rotationOffset)  |
			// 
			//      https://www.khronos.org/opengl/wiki/Data_Type_(GLSL)#Matrix_constructors
			mat2 matRotate2D = 
				mat2( vec2( cos(rotationOffset), sin(rotationOffset) ), 	// 1st column
					  vec2( -sin(rotationOffset), cos(rotationOffset) ) );	// 2nd column
			
			sampleUV.xy = matRotate2D * sampleUV.xy;
			// 
			// 1. Translate to 0.5,0.5:
			sampleUV.xy += vec2(0.5f, 0.5f);
		
		// Since it's only sampling greyscale, I'm just sampling red (will return 0 to 1)
		float heightSample = texture(heightMapTexture, sampleUV.xy ).r;
		
		vertPosition.y += (heightSample * heightMapScale);
		
	}//if (bUseHeightMap)
	
			
    gl_Position = MVP * vertPosition; 		// Used to be: vec4(vPosition, 1.0f);	// Used to be vPos
	
	// The location of the vertex in "world" space (not screen space)
	fVertWorldLocation = matModel * vertPosition;
	
	// Copy the vertex colour to the fragment shader
	// (if you want the colours from the original file used)
    fVertexColour = vColour;		// Used to be vCol
	
	// Calculate the normal based on any rotation we've applied.
	// This inverse transpose removes scaling and tranlation (movement) 
	// 	from the matrix.
	fNormal = matModelInverseTranspose * normalize(vNormal);
	fNormal = normalize(fNormal);
	
	// Copy the rest of the vertex values:
	fUVx2 = vUVx2;

};