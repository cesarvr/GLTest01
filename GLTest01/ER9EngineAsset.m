//
//  ER9EngineAsset.m
//  RotationTest
//
//  Created by Cesar Luis Valdez on 26/02/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9EngineAsset.h"

@implementation ER9EngineAsset

@synthesize vTexturas, textura;


/*
- (id)init
{
    self = [super init];
    if (self) {
       [self cargarTexturas];
        
        GLfloat buffer_textures[] = { 0.0f, 0.0f, 0.0f, 1.0f,
                                      0.0f, 1.0f, 0.0f, 1.0f,
                                      1.0f, 0.0f, 0.0f, 1.0f,
                                      1.0f, 1.0f, 0.0f, 1.0f};
        
        glGenBuffers(1, &vTexturas);
        glBindBuffer(GL_ARRAY_BUFFER, vTexturas);
        glBufferData(GL_ARRAY_BUFFER, sizeof(buffer_textures), buffer_textures, GL_STATIC_DRAW);
    }
    
    return self;
}
 
 */

+(GLuint)cargarTexturas{
    
    NSLog(@"loading texturas");
    
    //RyuSFA3.png
    NSString *rutaImagen =   [[NSBundle mainBundle] pathForResource:@"wood" ofType:@"jpg"];
    CGImageRef spriteImage = [UIImage imageWithContentsOfFile:rutaImagen].CGImage;
    if (!spriteImage)
    {
        NSLog(@"Failed to load image %@", rutaImagen);
        exit(1);
    }
    
    size_t width  = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8,     width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
     
    CGContextRelease(spriteContext);
    
    glGenTextures(1, &textura);
	glBindTexture(GL_TEXTURE_2D, textura);
    

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    GLenum err = glGetError();
    if (err != GL_NO_ERROR)
        NSLog(@"Error uploading texture. glError: 0x%04X", err);
 

    return textura; 
}


@end
