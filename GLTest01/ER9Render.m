//
//  ER9Render.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 04/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9Render.h"
#define M_TAU (2*M_PI)

@implementation ER9Render

GLuint Matrix, vector_buffer, indices_buffer;
GLKMatrix4 modelo, proyecion, mvp, view, viewMatrix;
GLKMatrix4 rotx,roty;
int tamano= 0;

float recx=0.0f , recy =0.0f;



-(ER9ProgramaGPU *)programa{
    
    if(!_programa)_programa = [[ER9ProgramaGPU alloc]init];
    return _programa;
}

-(id)initWithPoligono:(ER9PolyTestUno *)polygono{


    if(self = [super init]){
       vector_buffer = [polygono vector_buffer];
       indices_buffer = [polygono indices_buffer];
       
        
       Matrix = [self.programa getParametro:@"MVP"];
       tamano = [polygono indice_size];
       modelo = GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
                                0.0f, 1.0f, 0.0f, 0.0f,
                                0.0f, 0.0f, 1.0f, 0.0f,
                                0.0f, 0.0f, 0.0f, 1.0f);

        
    
    }


    return self;
}



-(void)setRotacionx:(float)posx setRotaciony:(float)posy{
    
       // modelo = GLKMatrix4Scale(modelo, 2.0f, 2.0f, 2.0f);
    
       rotx = GLKMatrix4MakeYRotation(posx);
        modelo = GLKMatrix4Multiply(modelo, rotx);

        roty = GLKMatrix4MakeZRotation(posx);
        modelo = GLKMatrix4Multiply(modelo, roty);
   
   
}

-(void)update {
    
 
   viewMatrix = GLKMatrix4MakeLookAt(0, 0, 15, 0, 0, 0, 0, 1, 0);
    
    
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 2, -1);
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    mvp = GLKMatrix4Multiply(mvp, modelo);
    
   
    /*
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 0.1f, 100.0f);

    
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    mvp = GLKMatrix4Multiply(mvp, modelo);
   
    */
    
    
    
    

    
    
}


-(void)render {
    

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
    
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vector_buffer);
	glVertexAttribPointer(0,3, GL_FLOAT, GL_FALSE, 0, (void*) 0);
    
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices_buffer);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 12*3);
    glDrawElements(GL_TRIANGLES, tamano, GL_UNSIGNED_SHORT, 0);
    glDisableVertexAttribArray(0);

}


@end
