//
//  ER9ProgramaGPU.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ER9ProgramaGPU : NSObject{
    GLuint _program;
}


-(GLuint)getParametro:(NSString *)param;
-(GLuint)getUniformParam:(NSString *)param;
-(bool)cargarPrograma;
-(bool)cargarVertex:(NSString *)vertexShd
     cargarFragment:(NSString *)fragmentShd;

-(void)usarProgram;
@end
