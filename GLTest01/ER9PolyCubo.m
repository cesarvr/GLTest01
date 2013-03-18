//
//  ER9PolyCubo.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 06/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9PolyCubo.h"

@implementation ER9PolyCubo

GLuint Matrix, vector_buffer, indices_buffer;
GLKMatrix4 modelo, proyecion, mvp, view, viewMatrix;
GLKMatrix4 rotx,roty;

/* Globals */
GLuint texture_id;
GLint uniform_mytexture;


static const int SIZE_PER_SIDE = 32;
static const float MIN_POSITION = -5.0f;
static const float POSITION_RANGE = 10.0f;

/** Additional constants. */
static const int POSITION_DATA_SIZE_IN_ELEMENTS = 4;
static const int NORMAL_DATA_SIZE_IN_ELEMENTS = 3;
static const int COLOR_DATA_SIZE_IN_ELEMENTS = 2;


int indexCount;
GLuint vector_buffer, indices_buffer;
int indices_size;
int pedazo_chk =0;

GLuint modeloVista, luzPos, posicion, normalV, color;
GLuint Matrix;

int BYTES_SIZE_FLOAT2 = sizeof(float);
/*const int STRIDE = (POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS + COLOR_DATA_SIZE_IN_ELEMENTS) * BYTES_PER_FLOAT;
 */
-(ER9ProgramaGPU *)programa{
    
    if(!_programa){
        
        _programa = [[ER9ProgramaGPU alloc]init];
        
        //inicializando.
        [_programa cargarVertex:@"LightTextura" cargarFragment:@"LightTextura"];
    }
    return _programa;
}




- (id)init
{
    self = [super init];
    if (self) {
        
        glEnable( GL_DEPTH_TEST );
        
        
        modelo = GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
                                0.0f, 1.0f, 0.0f, 0.0f,
                                0.0f, 0.0f, 1.0f, 0.0f,
                                0.0f, 0.0f, 0.0f, 1.0f);
        
        
          // NSString  *MV_MATRIX_UNIFORM      = @"u_MVMatrix";
        NSString  *TEXTURA                = @"u_Textura";
        NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
        NSString  *POSITION_ATTRIBUTE     = @"a_Position";
        NSString  *NORMAL_ATTRIBUTE       = @"a_Normal";
        NSString  *COLOR_ATTRIBUTE        = @"a_Textura";
  
        
        //  modeloVista = [self.programa getUniformParam:MV_MATRIX_UNIFORM];

        uniform_mytexture = [self.programa getUniformParam:TEXTURA];
        Matrix =      [self.programa getUniformParam:@"MVP"];
        luzPos      = [self.programa getUniformParam:LIGHT_POSITION_UNIFORM];
        posicion =    [self.programa getParametro:POSITION_ATTRIBUTE];
        normalV =     [self.programa getParametro:NORMAL_ATTRIBUTE];
        color =       [self.programa getParametro:COLOR_ATTRIBUTE];
        
        
        
        
        /*
         
         GLfloat cube_vertices[] = {
         // front
         -1.0, -1.0,  1.0,
         1.0, -1.0,  1.0,
         1.0,  1.0,  1.0,
         -1.0,  1.0,  1.0,
         // back
         -1.0, -1.0, -1.0,
         1.0, -1.0, -1.0,
         1.0,  1.0, -1.0,
         -1.0,  1.0, -1.0,
         };
         
         
         */
        
        
        static const GLfloat vertices[] = {
            
            //Front                 // color                //Normal
            -1.0, -1.0,  1.0,   0.0f, 0.0f,              0.0f, 0.0f, -1.0f,   //der      indices : 0,1,2,3
             1.0, -1.0,  1.0,   1.0f, 0.0f,              0.0f, 0.0f, -1.0f,  //izq
             1.0,  1.0,  1.0,   1.0f, 1.0f,              0.0f, 0.0f, -1.0f,  //top der
            -1.0,  1.0,  1.0,   0.0f, 1.0f,              0.0f, 0.0f, -1.0f,  //top izq
            
            //Back
           -1.0, -1.0, -1.0,    0.0f, 0.0f,              0.0f, 0.0f, 1.0f,     //der            4,5,6,7
            1.0, -1.0, -1.0,    1.0f, 0.0f,              0.0f, 0.0f, 1.0f,  //izq
            1.0,  1.0, -1.0,    1.0f, 1.0f,              0.0f, 0.0f, 1.0f, //top der
           -1.0,  1.0, -1.0,    0.0f, 1.0f,              0.0f, 0.0f, 1.0f
            
            
        }; // top izq
        
        
        
        
        
        static const unsigned short indices[] = {
            // front
            0, 1, 2,
            2, 3, 0,
            // top
            1, 5, 6,
            6, 2, 1,
            // back
            7, 6, 5,
            5, 4, 7,
            // bottom
            4, 0, 3,
            3, 7, 4,
            // left
            4, 5, 1,
            1, 0, 4,
            // right
            3, 2, 6,
            6, 7, 3,
        };
        
        
        indices_size = sizeof(indices) / sizeof(short);
        pedazo_chk = (POSITION_DATA_SIZE_IN_ELEMENTS + COLOR_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS) * BYTES_SIZE_FLOAT2;
        
        
        glGenBuffers(1, &_vector_buffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_indices_buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices  , GL_STATIC_DRAW);
        
        texture_id =  [ER9Asset cargarTexturas];
        
        
    }
    
    return self;
}


-(void)textura{


}



-(void)setRotacionx:(float)posx setRotaciony:(float)posy{
    
    // modelo = GLKMatrix4Scale(modelo, 2.0f, 2.0f, 2.0f);
    
    rotx = GLKMatrix4MakeYRotation(posx);
    modelo = GLKMatrix4Multiply(modelo, rotx);
    
    roty = GLKMatrix4MakeZRotation(posy);
    modelo = GLKMatrix4Multiply(modelo, roty);
    
    
}



-(void)render{
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture_id);
    glUniform1i(uniform_mytexture, /*GL_TEXTURE*/0);
    
    
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
    
    
    glVertexAttribPointer(posicion, POSITION_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo_chk, 0);
    glEnableVertexAttribArray(posicion);
    
    
    glVertexAttribPointer(color, COLOR_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo_chk,(void *)(POSITION_DATA_SIZE_IN_ELEMENTS * BYTES_SIZE_FLOAT2));
    glEnableVertexAttribArray(color);
    
    
    
    
    glVertexAttribPointer(normalV, NORMAL_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo_chk, (void*)((POSITION_DATA_SIZE_IN_ELEMENTS +COLOR_DATA_SIZE_IN_ELEMENTS)  * BYTES_SIZE_FLOAT2));
    glEnableVertexAttribArray(normalV);
    /*
     glVertexAttribPointer(color, COLOR_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false,
     STRIDE,(void *)((POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS) * BYTES_PER_FLOAT));
     glEnableVertexAttribArray(color);
     */
    //Draw
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
    glDrawElements(GL_TRIANGLE_STRIP, indices_size, GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

-(void)update{
    
    
    //modelo = GLKMatrix4Translate(modelo, 0.0f, 0.0f, -0.01f);
    
    viewMatrix = GLKMatrix4MakeLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
    
    
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 2, -1);
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    
    mvp = GLKMatrix4Multiply(mvp, modelo);
    
    
    glUniform3f(luzPos,0.0f, -0.7f , -0.7f);
}

@end
