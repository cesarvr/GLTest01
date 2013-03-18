//
//  ER9BlenderRenderMejorado.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 11/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h> 
#import "ER9ProgramaGPU.h"
#import "ER9CargarObj.h"
#import "ER9Modelo.h"

@interface ER9BlenderRenderMejorado : NSObject
{

    //programas GPU
    
    ER9ProgramaGPU *programaSinLuz,  *programa, *programaAnime, *programaPhong;
    

}

@property float aspect;


-(void)update;
-(void)render;
-(void)setRotacionx:(float)posx setRotaciony:(float)posy;
-(void)moverLuzx:(float)posx moverLuzy:(float)posy;
-(void)usarLuz;
-(void)normalShader;
-(void)animeShader;
-(void)phongShader; 

@end
