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



void main(){	

   // vec4 newColor = a_Color;
     vec4 newNormal = MVP * a_Normal;
    
     lightIntensity = max(0.0, dot(newNormal.xyz, u_LightPos));
    v_Textura = a_Textura;
	gl_Position = MVP * a_Position;

}