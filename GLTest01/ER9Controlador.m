//
//  ER9Controlador.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9Controlador.h"

@interface ER9Controlador ()


@property (strong, nonatomic) EAGLContext *context;
@end




@implementation ER9Controlador


- (IBAction)activarNormalShader:(id)sender {
    [self.dibujador5 normalShader];
}

- (IBAction)activarLuzShader:(id)sender {
    [self.dibujador5 usarLuz];
}

- (IBAction)activarAnime:(id)sender {
    [self.dibujador5 animeShader];
}

- (IBAction)activarPhong:(id)sender {
    [self.dibujador5 phongShader];
}


-(ER9BlenderRenderMejorado *)dibujador5{
    if (!_dibujador5) {
        
        //  ER9PolyTestUno *poly = [[ER9PolyTestUno alloc]init];
        
        _dibujador5 = [[ER9BlenderRenderMejorado alloc]init];
    }
    
    return _dibujador5;
    
    
}
/*

-(ER9PolyCubo *)dibujador4{
    if (!_dibujador4) {
        
        //  ER9PolyTestUno *poly = [[ER9PolyTestUno alloc]init];
        
        _dibujador4 = [[ER9PolyCubo alloc]init];
    }
    
    return _dibujador4;
    
    
}


-(ER9LightTexturasRender *)dibujador3{
    if (!_dibujador3) {
        
        //  ER9PolyTestUno *poly = [[ER9PolyTestUno alloc]init];
        
        _dibujador3 = [[ER9LightTexturasRender alloc]init];
    }
    
    return _dibujador3;
    
    
}
-(ER9GraphRender *)dibujador2{
    if (!_dibujador2) {
        
      //  ER9PolyTestUno *poly = [[ER9PolyTestUno alloc]init];
        
        _dibujador2 = [[ER9GraphRender alloc]init];
    }
    
    return _dibujador2;


}
-(ER9Render *)dibujador{

    if (!_dibujador) {
        
        ER9PolyTestUno *poly = [[ER9PolyTestUno alloc]init];
        
        _dibujador = [[ER9Render alloc]initWithPoligono:poly];
    }
    
    return _dibujador;

}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

  
   
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];
     glEnable( GL_DEPTH_TEST );
    
    [self.dibujador5 normalShader];

    
    NSLog(@"opengl init [fin]");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.dibujador5 render];
}

-(void)update {
    float aspecto = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    [self.dibujador5 setAspect:aspecto];
    [self.dibujador5 update];
}


float begin_y = 0.0f;
float begin_x = 0.0f;
float track_x = 0.0f;
float track_y = 0.0f; 
BOOL rotar = NO;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UITouch *touch in touches) {
        CGPoint location =  [touch locationInView:[touch view]];
      
        begin_y = location.y;
        begin_x = location.x;
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for (UITouch *touch in touches) {
        CGPoint location =  [touch locationInView:[touch view]];
              

        
        
        if(location.y != begin_y){
            if(location.y > begin_y){
                track_y=-0.05f;
                
            }else{
                track_y=0.05f;
            }
            rotar = YES;
        }
        
        if(location.x != begin_x){
            if(location.x > begin_x){
                track_x = 0.05f;
        
            }else{
                track_x = -0.05f;
            }
            rotar = YES;
        }
        
        NSLog(@"location.x -> %f   begin_x -> %f  REST-> %f", location.x,begin_x , track_x);

        
        if(rotar){
            [self.dibujador5 setRotacionx:track_x setRotaciony:track_y];
            //[self.dibujador5 moverLuzx:track_x moverLuzy:track_y];
            rotar =NO;
        }
        
    }
    track_x = 0.0f;
    track_y = 0.0f;
   
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     begin_y = 0.0f;
     begin_x = 0.0f;
     track_x = 0.0f;
     track_y = 0.0f;

 
}

@end
