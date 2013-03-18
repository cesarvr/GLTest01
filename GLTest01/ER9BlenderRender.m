//
//  ER9BlenderRender.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 09/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9BlenderRender.h"

@implementation ER9BlenderRender


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
static const int POSITION_DATA_SIZE_IN_ELEMENTS = 3;
static const int NORMAL_DATA_SIZE_IN_ELEMENTS = 3;
static const int COLOR_DATA_SIZE_IN_ELEMENTS = 2;


int indexCount;
GLuint vector_buffer, indices_buffer;
int indices_size;
int tamano_datos =0;



GLuint modeloVista, luzPos, posicion, normalV, color;
GLuint Matrix;

const int BYTES_SIZE_FLOAT5 = sizeof(float);


const int TAMANO_BUFFER = (POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS) * BYTES_SIZE_FLOAT5;



-(ER9ProgramaGPU *)programa{
    
    if(!_programa){
        
        _programa = [[ER9ProgramaGPU alloc]init];
        
        //inicializando.
        [_programa cargarVertex:@"modelo" cargarFragment:@"modelo"];
    }
    return _programa;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    
        
        
        modelo = GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
                                0.0f, 1.0f, 0.0f, 0.0f,
                                0.0f, 0.0f, 1.0f, 0.0f,
                                0.0f, 0.0f, 0.0f, 1.0f);
        
        
        // NSString  *MV_MATRIX_UNIFORM      = @"u_MVMatrix";
     //   NSString  *TEXTURA                = @"u_Textura";
        NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
        NSString  *POSITION_ATTRIBUTE     = @"a_Position";
        NSString  *NORMAL_ATTRIBUTE       = @"a_Normal";
       // NSString  *COLOR_ATTRIBUTE        = @"a_Textura";
        
        
        //  modeloVista = [self.programa getUniformParam:MV_MATRIX_UNIFORM];
        
       // uniform_mytexture = [self.programa getUniformParam:TEXTURA];
        Matrix =      [self.programa getUniformParam:@"MVP"];
        luzPos      = [self.programa getUniformParam:LIGHT_POSITION_UNIFORM];
        posicion =    [self.programa getParametro:POSITION_ATTRIBUTE];
        normalV =     [self.programa getParametro:NORMAL_ATTRIBUTE];
       // color =       [self.programa getParametro:COLOR_ATTRIBUTE];
        
   
        
        
        ER9Asset *asset = [[ER9Asset alloc]init];
   
      
        GLfloat vertices[[asset.vposiciones count]];
        unsigned short indices[[asset.indices count]]; 
        
        int count =0;
        for (NSNumber *ind in asset.vposiciones) {
           vertices[count++]= [ind floatValue];
        }
        count =0;
        for (NSNumber *ind in asset.indices) {
           indices[count++]= [ind shortValue];
        }
        indexCount = [asset.indices count];
        NSLog(@"%d  index_count", indexCount);
        NSLog(@"%ld  vertex size", sizeof(vertices));

            
        glGenBuffers(1, &_vector_buffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_indices_buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices  , GL_STATIC_DRAW);        
  
    }
    
    return self;

}


-(void)textura{
    
    
}



-(void)setRotacionx:(float)posx setRotaciony:(float)posy{
    

    rotx = GLKMatrix4MakeYRotation(posx);
    modelo = GLKMatrix4Multiply(modelo, rotx);
    
    roty = GLKMatrix4MakeZRotation(posy);
    modelo = GLKMatrix4Multiply(modelo, roty);
    
    
}



-(void)render{
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
   
    glVertexAttribPointer(posicion, POSITION_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, TAMANO_BUFFER, 0);
    glEnableVertexAttribArray(posicion);

    glVertexAttribPointer(normalV, NORMAL_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, TAMANO_BUFFER, (void *)(POSITION_DATA_SIZE_IN_ELEMENTS * BYTES_SIZE_FLOAT5));
    glEnableVertexAttribArray(normalV);
 
    int size;  glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size); 

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
    glDrawElements(GL_TRIANGLES, indexCount, GL_UNSIGNED_SHORT, 0);

    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

}

-(void)update{
    
    
    //modelo = GLKMatrix4Translate(modelo, 0.0f, 0.0f, -0.01f);
    
    viewMatrix = GLKMatrix4MakeLookAt(0, 2.0, 4.0, 0, 0, 0, 0, 1.0, 0);
    
    
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 1.5, 100.0f);
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    
    mvp = GLKMatrix4Multiply(mvp, modelo);
    
    
    glUniform3f(luzPos,0.0f, -8.7f , -2.7f);
}



@end
