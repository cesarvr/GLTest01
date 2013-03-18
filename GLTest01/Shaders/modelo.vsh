//
//  Shader.vsh
//  testgl
//
//  Created by Cesar Luis Valdez on 28/11/12.
//  Copyright (c) 2012 Cesar Luis Valdez. All rights reserved.
//

uniform mat4 MVP;
uniform vec3 u_LightPos;


attribute vec4 a_Position;		// Per-vertex position information we will pass in.
attribute vec2 a_Textura;			// Per-vertex color information we will pass in.
attribute vec4 a_Normal;		// Per-vertex normal information we will pass in.


varying vec2 v_Textura;			// This will be passed into the fragment shader.
varying float lightIntensity;

varying lowp vec4 colorVarying;

struct lightSource
{
  vec4 position;
  vec4 diffuse;
};
lightSource light0 = lightSource(
    vec4(u_LightPos,1.0),
    vec4(1.0, 1.0, 0.8, 1.0)
);

struct material
{
  vec4 diffuse;
};
material mymaterial = material(vec4(0.3, 0.3, 1.0, 1.0));



void main(){
    
    // vec4 newColor = a_Color;
    vec4 newNormal = MVP * a_Normal;
    vec4 lightDirection = normalize(light0.position);
       
    vec3 diffuseReflection = vec3(light0.diffuse) * vec3(mymaterial.diffuse)
    * max(0.0, dot(newNormal, lightDirection));
    
    
    
    colorVarying =  vec4(diffuseReflection, 1.0);

    v_Textura = a_Textura;
	gl_Position = MVP * a_Position;
    
}