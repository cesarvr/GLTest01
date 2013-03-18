
precision highp float;
uniform vec3 u_LightPos;

varying vec3 posicion;
varying vec3 normal;

uniform vec3 mambient;
uniform vec3 mdiffuse;
uniform vec3 mspecular;



uniform vec3 lambient;
uniform vec3 ldiffuse;
uniform vec3 lspecular;

uniform float shininess;


void main()
{
 
    
     float dist = length(posicion - u_LightPos);
     float att = 1.0/(1.0+0.1 * dist  + 0.01 * 1.0*dist*dist);
    
     //float shininess = 59.0;
    
     vec3 ambiente = mambient * lambient;
    
     vec3 surf2light = normalize(u_LightPos - posicion);
     vec3 norm = normalize(normal);
   
    
    /*
        Generando luz difusa;
     */
     float diffuse_contribucion = max(0.0,dot(norm, surf2light));
     vec3 difusa = diffuse_contribucion * (mdiffuse * ldiffuse);
    
    
    /*
        Generando posicion observador.
     */
    
     vec3 eyePos = normalize(-posicion);
    
    
     /*
    lowp vec4 vLightDirection = normalize(vec4(posicion,1.0) - vec4(u_LightPos,1.0));
    lowp vec4 vCameraDirection = normalize( vec4(eyePos,1.0) - vec4(posicion,1.0));
    
   
     Generando reflexion.
     */
     vec3 reflexion = reflect(-surf2light,norm);
    
    /*
        Reflexion TEST
     */
    //lowp vec3 reflexion = reflect( vLightDirection, vTransformedNormal );
    
    
    /*
     Generando specular contribucion.
     */
    
     float specular_contribucion =pow(max(0.0, dot(eyePos,reflexion)),shininess);
    
     vec3 specular = specular_contribucion * lspecular * mspecular;
    
    
    gl_FragColor = vec4((ambiente+difusa+specular),1.0);

}
