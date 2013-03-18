
varying highp float lightIntensity;
varying highp vec2 v_Textura;          	// This is the color from the vertex shader interpolated across the


uniform sampler2D u_Textura;


void main()
{
    
     lowp vec4 yellow = vec4(0.3, 0.3, 0.3, 1.0);
     lowp vec2 flipped_texcoord = vec2(v_Textura.x, 1.0 - v_Textura.y);
    gl_FragColor = yellow; //vec4((texture2D(u_Textura, flipped_texcoord) * lightIntensity * 0.2).rgb, 1.0) ;
   
    /* 
    gl_FragColor[0] = gl_FragCoord.x/640.0;
    gl_FragColor[1] = gl_FragCoord.y/480.0;
    gl_FragColor[2] = 0.5;
    gl_FragColor[3] = floor(mod(gl_FragCoord.y, 2.0));*/
}
