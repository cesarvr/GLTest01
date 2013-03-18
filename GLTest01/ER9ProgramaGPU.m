//
//  ER9ProgramaGPU.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9ProgramaGPU.h"

@implementation ER9ProgramaGPU


/** Identifiers for our uniforms and attributes inside the shaders. */
//const NSString MVP_MATRIX_UNIFORM = @"u_MVPMatrix";



- (id)init
{
    self = [super init];
    if (self) {
       // [self cargarPrograma];
    }
    return self;
}

-(bool)cargarVertex:(NSString *)vertexShd cargarFragment:(NSString *)fragmentShd{

    
    NSLog(@"cargando vertex shader:  %@ ", vertexShd);
    NSLog(@"cargando fragment shader:  %@ ", fragmentShd);
    
    
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:vertexShd ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShd ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        NSLog(@"Error al compilar saliendo");
        
        return NO;
    }
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    glUseProgram(_program);
    return YES;


}
-(bool)cargarPrograma{

       return [self cargarVertex:@"Shader" cargarFragment:@"Shader"];
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}


- (GLuint)getParametro:(NSString *)param{
    //NSLog(@"SHADER parametros: %@",param);
    
    GLuint temp =  glGetAttribLocation(_program, [param UTF8String]);
    assert(temp != 0xFFFFFFFF);
    
    return temp;
}

-(GLuint)getUniformParam:(NSString *)param{
    //NSLog(@"Uniform parametros: %@",param);
    GLuint temp =  glGetUniformLocation(_program, [param UTF8String]);
    assert(temp != 0xFFFFFFFF);
    
    return temp;

}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

-(void)usarProgram{


glUseProgram(_program);
}

@end
