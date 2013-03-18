//
//  ER9PolyCubo.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 06/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ER9ProgramaGPU.h"
#import "ER9Asset.h"

@interface ER9PolyCubo : NSObject



@property float aspect;
@property int indice_size;
@property (nonatomic) GLuint vector_buffer, indices_buffer;
@property (strong, nonatomic) ER9ProgramaGPU *programa;



-(void)update;
-(void)render;
-(void)setRotacionx:(float)posx setRotaciony:(float)posy;
-(void)textura;


@end
