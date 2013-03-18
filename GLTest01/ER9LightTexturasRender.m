//
//  ER9LightTexturasRender.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 07/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9LightTexturasRender.h"

@implementation ER9LightTexturasRender




GLKMatrix4 modelo, proyecion, mvp, view, viewMatrix;
GLKMatrix4 rotx,roty;

static const int SIZE_PER_SIDE = 32;
static const float MIN_POSITION = -5.0f;
static const float POSITION_RANGE = 10.0f;

/** Additional constants. */
static const int POSITION_DATA_SIZE_IN_ELEMENTS = 3;
static const int NORMAL_DATA_SIZE_IN_ELEMENTS = 3;
static const int COLOR_DATA_SIZE_IN_ELEMENTS = 4;


int indexCount;
GLuint vector_buffer, indices_buffer;
int indices_size;
int pedazo =0; 

GLuint modeloVista, luzPos, posicion, normalV, color;
GLuint Matrix;

 int BYTES_SIZE_FLOAT = sizeof(float);



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
        
     
        //NSString  *MV_MATRIX_UNIFORM      = @"u_MVMatrix";
        NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
        NSString  *POSITION_ATTRIBUTE     = @"a_Position";
        NSString  *NORMAL_ATTRIBUTE       = @"a_Normal";
        NSString  *COLOR_ATTRIBUTE        = @"a_Color";
        
        
        Matrix =      [self.programa getUniformParam:@"MVP"];
      //  modeloVista = [self.programa getUniformParam:MV_MATRIX_UNIFORM];
        luzPos      = [self.programa getUniformParam:LIGHT_POSITION_UNIFORM];
        posicion =    [self.programa getParametro:POSITION_ATTRIBUTE];
        normalV =     [self.programa getParametro:NORMAL_ATTRIBUTE];
        color =       [self.programa getParametro:COLOR_ATTRIBUTE];
        
        
        
        
        static const GLfloat vertices[] = {
            
             //atras
            1.0f,-1.0f, -1.0f,   1.0f, 0.4f, 0.3f,1.0f, 0.0f, 0.0f, -1.0f,   //der      indices : 0,1,2,3
           -1.0f,-1.0f, -1.0f,   1.0f, 0.3f, 0.3f,1.0f, 0.0f, 0.0f, -1.0f,  //izq
            1.0f, 1.0f, -1.0f,   1.0f, 0.2f, 0.3f,1.0f, 0.0f, 0.0f, -1.0f,  //top der
           -1.0f, 1.0f, -1.0f,   1.0f, 0.1f, 0.3f,1.0f, 0.0f, 0.0f, -1.0f,  //top izq
            
            //adelante
            1.0f,-1.0f, 1.0f,    0.5f, 0.5f, 1.0f,1.0f, 0.0f, 0.0f, 1.0f,     //der            4,5,6,7
            -1.0f,-1.0f,1.0f,    0.5f, 0.6f, 1.0f,1.0f, 0.0f, 0.0f, 1.0f,  //izq
            1.0f, 1.0f, 1.0f,    0.5f, 0.5f, 1.0f,1.0f, 0.0f, 0.0f, 1.0f, //top der
            -1.0f, 1.0f,1.0f,    0.5f, 0.4f, 1.0f,1.0f, 0.0f, 0.0f, 1.0f
        
        
        }; // top izq
        
        
        
        
        
        static const unsigned short indices[] = {0, 1, 2,
            2, 3, 1,
            
            0,1,4, 4,1,5,  //bottom
            4,5,6, 6,7,5,  //otra cara
                       
        };
        
        
        indices_size = sizeof(indices) / sizeof(short); 
        pedazo = (POSITION_DATA_SIZE_IN_ELEMENTS + COLOR_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS) * BYTES_SIZE_FLOAT;
        
        
        glGenBuffers(1, &_vector_buffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_indices_buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices  , GL_STATIC_DRAW);

    
    
    
    
    }
    
    return self;
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
    
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
       
    glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
   
     
    glVertexAttribPointer(posicion, POSITION_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo, 0);
    glEnableVertexAttribArray(posicion);
    
    
    glVertexAttribPointer(color, COLOR_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo,(void *)(POSITION_DATA_SIZE_IN_ELEMENTS * BYTES_SIZE_FLOAT));
    glEnableVertexAttribArray(color);
    
    
    
 
    glVertexAttribPointer(normalV, NORMAL_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, pedazo, (void*)((POSITION_DATA_SIZE_IN_ELEMENTS +COLOR_DATA_SIZE_IN_ELEMENTS)  * BYTES_SIZE_FLOAT));
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
    
    
    viewMatrix = GLKMatrix4MakeLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
    
    
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 2, -1);
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    
    mvp = GLKMatrix4Multiply(mvp, modelo);
    
   
        glUniform3f(luzPos,0.0f, 0.0f , -0.1f);
}



@end
