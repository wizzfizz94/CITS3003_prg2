#version 130

in  vec4 vPosition;
in  vec3 vNormal;
in  vec2 vTexCoord;

out vec3 v_Normal;
out vec3 pos;
out vec2 texCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

//*************************
in ivec4 boneIDs;
in  vec4 boneWeights;
uniform mat4 boneTransforms[64];
//**************************

void main()
{
	mat4 boneTransform = 	boneWeights.x * boneTransforms[boneIDs.x]
    			    		+ boneWeights.y * boneTransforms[boneIDs.y]
    			    		+ boneWeights.z * boneTransforms[boneIDs.z]
    			    		+ boneWeights.w * boneTransforms[boneIDs.w];
	
    // Transform vertex position into eye coordinates , pass it into fragmnet shader
    pos = (ModelView * boneTransform * vPosition).xyz;

    // Transform vertex normal into eye coordinates (assumes scaling is uniform across dimensions)
    v_Normal = normalize( (ModelView * boneTransform * vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vPosition;
    texCoord = vTexCoord;
}
