//
//  ER9BlenderRenderMejorado.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 11/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9BlenderRenderMejorado.h"


#define SHADER_NORMAL 0
#define SHADER_LUZ  1
#define SHADER_ANIME 2
#define SHADER_PHONG 3 


@implementation ER9BlenderRenderMejorado


int mode = SHADER_NORMAL;


GLKMatrix4 modelo, modelviewproyection;

//VBOs
GLuint vbo, vnbo;
GLfloat luzx = 0.0f, luzy = -8.7f;


//Shader Variables
GLuint modeloVista, luzPos, posicion, normalV, matrix_view_proyection;


/** Additional constants. */
static const int POSITION_DATA_SIZE_IN_ELEMENTS = 3;
static const int NORMAL_DATA_SIZE_IN_ELEMENTS = 3;

NSString  *MATRIX_MODELO = @"MVP";
NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
NSString  *POSITION_ATTRIBUTE     = @"a_Position";
NSString  *NORMAL_ATTRIBUTE       = @"a_Normal";




int tamano_vertices;




-(void)usarLuz{

    mode = SHADER_LUZ;
    
}
-(void)normalShader{

    mode = SHADER_NORMAL;
    

}

-(void)animeShader{

    mode = SHADER_ANIME;
    

}

-(void)phongShader{
    
    mode = SHADER_PHONG;

}

- (id)init
{
    self = [super init];
    if (self) {
         

        programaSinLuz = [[ER9ProgramaGPU alloc]init];
        [programaSinLuz cargarVertex:@"shaderSinLuz" cargarFragment:@"shaderSinLuz"];
        
        programa = [[ER9ProgramaGPU alloc]init];
        [programa cargarVertex:@"modelo" cargarFragment:@"modelo"];
        
        programaAnime = [[ER9ProgramaGPU alloc]init];
        [programaAnime cargarVertex:@"Toon" cargarFragment:@"Toon"];
        
        programaPhong = [[ER9ProgramaGPU alloc]init];
        [programaPhong cargarVertex:@"phong" cargarFragment:@"phong"];
        
        
        
        modelo = GLKMatrix4Make(1.0f, 0.0f, 0.0f, 0.0f,
                                0.0f, 1.0f, 0.0f, 0.0f,
                                0.0f, 0.0f, 1.0f, 0.0f,
                                0.0f, 0.0f, 0.0f, 1.0f);
        
        
        // NSString  *MV_MATRIX_UNIFORM      = @"u_MVMatrix";
        // NSString  *TEXTURA                = @"u_Textura";
        // NSString  *COLOR_ATTRIBUTE        = @"a_Textura";
        

  
        
        
        ER9CargarObj   *obj = [[ER9CargarObj alloc]init];
        NSMutableArray *posiciones =  [[obj modelo] posiciones];
        NSMutableArray *normales   =  [[obj modelo] normales];
        
        
        tamano_vertices = [posiciones count];
        
        GLfloat vposicion[tamano_vertices];
        GLfloat vnormal[[normales count]];
        
        
        unsigned int x= 0;
        for (NSNumber *vertex in posiciones) 
            vposicion[x++] = [vertex floatValue];
        
        
        x = 0;
        for (NSNumber *nrm in normales)
            vnormal[x++] = [nrm floatValue];
        
        
        
       
        glGenBuffers(1, &vbo);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vposicion), vposicion, GL_STATIC_DRAW);
        
        glGenBuffers(1, &vnbo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vnbo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vnormal), vnormal  , GL_STATIC_DRAW);
        
        
        
        
    }
    return self;
}


-(void)render{
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    

    switch (mode) {
            
        case SHADER_LUZ:
            matrix_view_proyection      =      [programa getUniformParam:MATRIX_MODELO];
            luzPos                      =      [programa getUniformParam:LIGHT_POSITION_UNIFORM];
            posicion                    =      [programa getParametro:POSITION_ATTRIBUTE];
            normalV                     =      [programa getParametro:NORMAL_ATTRIBUTE];
            [programa usarProgram];
            break;
            
        case SHADER_NORMAL:
            matrix_view_proyection      =      [programaSinLuz getUniformParam:MATRIX_MODELO];
            //luzPos                      =      [programaSinLuz getUniformParam:LIGHT_POSITION_UNIFORM];
            posicion                    =      [programaSinLuz getParametro:POSITION_ATTRIBUTE];
            normalV                     =      [programaSinLuz getParametro:NORMAL_ATTRIBUTE];
            [programaSinLuz usarProgram];
            break;
            
        case SHADER_ANIME:
            matrix_view_proyection      =      [programaAnime getUniformParam:@"modelViewProjMatrix"];
         //   luzPos                      =      [programaAnime getUniformParam:LIGHT_POSITION_UNIFORM];
            posicion                    =      [programaAnime getParametro:@"position"];
            normalV                     =      [programaAnime getParametro:@"normal"];
            GLuint toonDiffuseColor     =      [programaAnime getUniformParam:@"DiffuseColor"];
            GLuint toonPhongColor       =      [programaAnime getUniformParam:@"PhongColor"];
            GLuint toonEdge             =      [programaAnime getUniformParam:@"Edge"];
            GLuint toonPhong            =      [programaAnime getUniformParam:@"Phong"];

            
            
          
			glUniform3f(toonDiffuseColor, 1.0, 1.0, 0.0);
			glUniform3f(toonPhongColor, 0.5, 0.5, 0.0);
			glUniform1f(toonEdge, 0.4);
			glUniform1f(toonPhong, 0.1);

            
            
            [programaAnime usarProgram]; 
            break;
        case SHADER_PHONG:
            
            matrix_view_proyection      =      [programaPhong getUniformParam:MATRIX_MODELO];
            luzPos                      =      [programaPhong getUniformParam:LIGHT_POSITION_UNIFORM];
            posicion                    =      [programaPhong getParametro:POSITION_ATTRIBUTE];
            normalV                     =      [programaPhong getParametro:NORMAL_ATTRIBUTE];

            GLuint mambient = [programaPhong getUniformParam:@"mambient"];
            GLuint mdiffuse = [programaPhong getUniformParam:@"mdiffuse"];
            GLuint mspecular = [programaPhong getUniformParam:@"mspecular"];
            GLuint normalM = [programaPhong getUniformParam:@"normalMatrix"];
            
            
           
         
            GLuint lambient = [programaPhong getUniformParam:@"lambient"];
            GLuint ldiffuse = [programaPhong getUniformParam:@"ldiffuse"];
            GLuint lspecular = [programaPhong getUniformParam:@"lspecular"];
            
             GLuint shininess = [programaPhong getUniformParam:@"shininess"];
            
            
            GLKMatrix3 normalMatrix =  GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelo), NULL);
            glUniformMatrix3fv(normalM,  1, 0, normalMatrix.m);

            
            glUniform3f(mambient, 1.0,0.0,0.0);
            glUniform3f(mdiffuse, 0.6, 0.6, 0.6);
            glUniform3f(mspecular, 1.0, 1.0, 1.0);
           
            
            
            glUniform3f(lambient, 0.2, 0.2, 0.2);
            glUniform3f(ldiffuse, 0.6, 0.6, 0.6);
            glUniform3f(lspecular, 1.0, 1.0, 1.0);
    
            glUniform1f(shininess, 25.0);
            
            [programaPhong usarProgram];
            break;
            
            
        default:
            break;
    }
    
    
    glUniformMatrix4fv(matrix_view_proyection, 1, GL_FALSE, modelviewproyection.m);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glVertexAttribPointer(posicion, POSITION_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, 0, 0);
    glEnableVertexAttribArray(posicion);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, vnbo);
    glVertexAttribPointer(normalV, NORMAL_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, 0, (void *)0);
    glEnableVertexAttribArray(normalV);
    
    
    int size;  glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    
    glDrawArrays(GL_TRIANGLES, 0, (tamano_vertices/3));
    
   // glBindBuffer(GL_ARRAY_BUFFER, 0);
   // glBindBuffer(GL_ARRAY_BUFFER, 0);
    
}

-(void)update{
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 2.0, 4.0, 0, 0, 0, 0, 1.0, 0);
    
    
    GLKMatrix4 proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 1.5, 100.0f);
    modelviewproyection = GLKMatrix4Multiply(proyecion, viewMatrix);
    
    modelviewproyection = GLKMatrix4Multiply(modelviewproyection, modelo);
    
    
    glUniform3f(luzPos,luzx, luzy , -2.7f);
}

-(void)setRotacionx:(float)posx setRotaciony:(float)posy{
    
    GLKMatrix4 rotx = GLKMatrix4MakeYRotation(posx);
    modelo = GLKMatrix4Multiply(modelo, rotx);
    
    GLKMatrix4 roty = GLKMatrix4MakeZRotation(posy);
    modelo = GLKMatrix4Multiply(modelo, roty);

}


-(void)moverLuzx:(float)posx moverLuzy:(float)posy{
   
    
    luzx += (posx*2.0f);
    luzy += (posy*2.0f);
    
 glUniform3f(luzPos,luzx, luzy , -luzx);

}
    

@end
