//
//  Shader.vsh
//  testgl
//
//  Created by Cesar Luis Valdez on 28/11/12.
//  Copyright (c) 2012 Cesar Luis Valdez. All rights reserved.
//

uniform mat4 MVP;
uniform mat3 normalMatrix;


attribute vec3 a_Position;      // Per-vertex position information we will pass in.
attribute vec3 a_Normal;        // Per-vertex normal information we will pass in.

varying vec3 posicion;
varying vec3 normal;



void main(){
    
    normal =  normalMatrix * a_Normal;
    posicion = a_Position;
    gl_Position = MVP * vec4(a_Position,1.0);

}