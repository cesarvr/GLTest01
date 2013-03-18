//
//  Shader.vsh
//  testgl
//
//  Created by Cesar Luis Valdez on 28/11/12.
//  Copyright (c) 2012 Cesar Luis Valdez. All rights reserved.
//
uniform mat4 u_MVMatrix;		// A constant representing the combined model/view matrix.
uniform mat4 MVP;

attribute vec4 a_Position;		// Per-vertex position information we will pass in.
attribute vec4 a_Color;			// Per-vertex color information we will pass in.
attribute vec3 a_Normal;		// Per-vertex normal information we will pass in.

varying vec3 v_Position;		// This will be passed into the fragment shader.
varying vec4 v_Color;			// This will be passed into the fragment shader.
varying vec3 v_Normal;			// This will be passed into the fragment shader.




void main(){	


  
    
    v_Normal = vec3(u_MVMatrix * vec4(a_Normal, 0.0));
    v_Position = vec3(u_MVMatrix * a_Position);
    v_Color = a_Color;
    
	gl_Position = MVP * a_Position;

}