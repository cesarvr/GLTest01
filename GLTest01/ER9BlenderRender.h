//
//  ER9BlenderRender.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 09/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ER9ProgramaGPU.h"
#import "ER9Asset.h"
#import "ER9Vertices.h"
#import "ER9CargarObj.h"

@interface ER9BlenderRender : NSObject


@property float aspect;
@property int indice_size;
@property (nonatomic) GLuint vector_buffer, indices_buffer, indices_normal_indice, normales_buffer;
@property (strong, nonatomic) ER9ProgramaGPU *programa;



-(void)update;
-(void)render;
-(void)setRotacionx:(float)posx setRotaciony:(float)posy;
-(void)textura;


@end
