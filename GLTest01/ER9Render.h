//
//  ER9Render.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ER9ProgramaGPU.h"
#import "ER9PolyTestUno.h"
@interface ER9Render : NSObject{

 float _rotation;

}

@property (strong, nonatomic) ER9ProgramaGPU *programa;
@property (nonatomic, readonly) NSTimeInterval timeSinceLastUpdate;
@property float aspect;
@property float rotacion;


-(id)initWithPoligono:(ER9PolyTestUno *)polygono;
-(void)setRotacionx:(float)posx setRotaciony:(float)posy;
-(void)update;
-(void)render;
@end
