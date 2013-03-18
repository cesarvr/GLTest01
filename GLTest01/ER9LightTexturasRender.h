//
//  ER9LightTexturasRender.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 07/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ER9ProgramaGPU.h"


@interface ER9LightTexturasRender : NSObject



@property float aspect;
@property int indice_size;
@property (nonatomic) GLuint vector_buffer, indices_buffer;
@property (strong, nonatomic) ER9ProgramaGPU *programa;



-(void)update;
-(void)render;
-(void)setRotacionx:(float)posx setRotaciony:(float)posy;

@end
