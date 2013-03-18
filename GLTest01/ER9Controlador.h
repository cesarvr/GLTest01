//
//  ER9Controlador.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

/*
#import "ER9Render.h"
#import "ER9GraphRender.h"
#import "ER9LightTexturasRender.h"
#import "ER9PolyCubo.h"
#import "ER9BlenderRender.h"
*/
#import "ER9BlenderRenderMejorado.h"

@interface ER9Controlador : GLKViewController
/*
@property(strong, nonatomic) ER9Render *dibujador;
@property(strong, nonatomic) ER9GraphRender *dibujador2;
@property(strong, nonatomic) ER9LightTexturasRender *dibujador3;
@property(strong, nonatomic) ER9PolyCubo *dibujador4;
*/
- (IBAction)activarNormalShader:(id)sender;
- (IBAction)activarLuzShader:(id)sender;
- (IBAction)activarAnime:(id)sender;
- (IBAction)activarPhong:(id)sender;


@property(strong, nonatomic) ER9BlenderRenderMejorado *dibujador5;

@end
