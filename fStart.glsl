#version 130
uniform vec4 LightPosition;
uniform vec4 LightPosition2;
uniform float Shininess;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform sampler2D texture;
uniform float texScale;

in  vec3 v_Normal;      //interpolated normal
in  vec3 pos;           //interpolated position
// The third coordinate is always 0.0 and is discarded
in  vec2 texCoord;

out vec4 fColor;

void main()
{
    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;
    //light
    vec3 Lvec2 = LightPosition2.xyz;
    //***************Part F***********************
    float a = 1.5;
    float b = 0.2;
    float c = 0.5;
    float d = length(Lvec);
    float d2 = length(Lvec2);
    float light_attenuation = 1/(a*pow(d,2) + b*pow(d,1) + c);
    float light_attenuation2 = 1/(a*pow(d2,2) + b*pow(d2,1) + c);
    //********************************************
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 L2 = normalize( Lvec2 );   // Direction to the second light source is constant, equals to LightPosition2.xyz
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );  // Halfway vector fro the scond light source

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;
    vec3 ambient2 = AmbientProduct2;

    float Kd = max( dot(L, v_Normal), 0.0 );   //if L and N face away each other , dot() will give negative light, so use max to cap at 0
    vec3  diffuse = Kd*DiffuseProduct;
    float Kd2 = max( dot(L2, v_Normal), 0.0 );   //if L and N face away each other , dot() will give negative light, so use max to cap at 0
    vec3  diffuse2 = Kd2*DiffuseProduct2;

    float Ks = pow( max(dot(v_Normal, H), 0.0), Shininess );
    float Ks2 = pow( max(dot(v_Normal, H), 0.0), Shininess );
    //********************Part H*********************
    vec3 white = vec3(0.5,0.5,0.5);             //make the specular component whiter
    vec3  specular = Ks * (SpecularProduct + white );
    vec3  specular2 = Ks2 * (SpecularProduct2 + white );
    //***********************************************
    if( dot(L, v_Normal) < 0.0 ) {
        specular = vec3(0.0, 0.0, 0.0);
    }
    if( dot(L2, v_Normal) < 0.0 ) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }


    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    //***************Part F***********************
    vec4 color;
    color.rgb = globalAmbient   + light_attenuation *(diffuse + ambient ) + light_attenuation2 *(diffuse2 + ambient2 ) ;
    //********************************************
    color.a = 1.0;
    //********************Part H*********************
    //specular component does not depend on texture
    fColor =    color 
                //get texel RGB color
                * texture2D( texture , texCoord * texScale );   //get texel RGB      
                + vec4(light_attenuation * specular , 1.0)
                + vec4(light_attenuation2 * specular2 , 1.0);  
    //***********************************************
}
