//
//  ER9Asset.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 08/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9Asset.h"

@implementation ER9Asset


GLuint vTexturas, textura; //vBuffer, Matrix,


-(NSMutableArray *)vposiciones{
    if (!_vposiciones) {
        _vposiciones = [[NSMutableArray alloc]initWithCapacity:5];
       
    }

    return _vposiciones; 
}

-(NSMutableArray *)indices{
    if (!_indices) {
        _indices = [[NSMutableArray alloc]initWithCapacity:5];

    }
    
    return _indices;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self cargarModelo];
    }
    return self;
}

+(GLuint)cargarTexturas{
    
    NSLog(@"loading texturas");
    
    //RyuSFA3.png
    NSString *rutaImagen =   [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"jpg"];
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

-(void)cargarModelo{
  
    NSString *rutaImagen = [[NSBundle mainBundle] pathForResource:@"monkeyvn" ofType:@"obj"]; 
    NSString *fichero = [NSString stringWithContentsOfFile:rutaImagen encoding:NSUTF8StringEncoding error:nil];

    NSMutableArray *array_triangulos = [[NSMutableArray alloc]initWithCapacity:5];
   
    
    
    for (NSString *line in [fichero componentsSeparatedByString:@"\n"]) {
        
        if ([line hasPrefix:@"v"]) {
           
            NSArray *vertices = [line componentsSeparatedByString:@" "];
            
            ER9Vertices *triangulos = [[ER9Vertices alloc]init];
            [triangulos setX:[vertices[1] floatValue]];
            [triangulos setY:[vertices[2] floatValue]];
            [triangulos setZ:[vertices[3] floatValue]];
            
            [array_triangulos addObject:triangulos];
        }
        

        if ([line hasPrefix:@"f"]) {
            
            NSArray *vertices = [line componentsSeparatedByString:@" "];
          
            for (NSString *indices in vertices)
                if (![indices isEqual: @"f"])
                    [self.indices addObject:[NSNumber numberWithShort:[indices intValue]]];
   
        }

    }

    for (int i = 0; i < [array_triangulos count]; i+=3) {
    
       unsigned short indice = [[self.indices objectAtIndex:i] shortValue];
        
        ER9Vertices *vtmp = [array_triangulos objectAtIndex:i];
        GLKVector3 trianguloA = GLKVector3Make(vtmp.x, vtmp.y, vtmp.z);
        
        vtmp = [array_triangulos objectAtIndex:i+1];
        GLKVector3 trianguloB = GLKVector3Make(vtmp.x, vtmp.y, vtmp.z);
        
        vtmp = [array_triangulos objectAtIndex:i+2];
        GLKVector3 trianguloC = GLKVector3Make(vtmp.x, vtmp.y, vtmp.z);
        
        GLKVector3 vectorA =  GLKVector3Subtract(trianguloB,trianguloA);
        GLKVector3 vectorB =  GLKVector3Subtract(trianguloC,trianguloA);
        
        GLKVector3 vectorCross = GLKVector3CrossProduct(vectorA, vectorB);
        GLKVector3 normalizado =  GLKVector3Normalize(vectorCross);
        
        [self addVertices:trianguloA addNormales:normalizado];
        [self addVertices:trianguloB addNormales:normalizado];
        [self addVertices:trianguloC addNormales:normalizado]; 
    
    }

}




-(void)addVertices:(GLKVector3)vertice addNormales:(GLKVector3)normales{

    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.x]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.y]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.z]];
      
    
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.x]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.y]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.z]];
}

@end
