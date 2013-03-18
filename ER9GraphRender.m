//
//  ER9GraphRender.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 06/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9GraphRender.h"

@implementation ER9GraphRender


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


GLuint modeloVista, luzPos, posicion, normalV, color;
GLuint Matrix;

const int BYTES_PER_FLOAT = sizeof(float);
const int STRIDE = (POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS + COLOR_DATA_SIZE_IN_ELEMENTS) * BYTES_PER_FLOAT;

-(ER9ProgramaGPU *)programa{
    
    if(!_programa)_programa = [[ER9ProgramaGPU alloc]init];
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

        
        int floatsPerVertex = POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS
        + COLOR_DATA_SIZE_IN_ELEMENTS;
     
     //   int size_map = SIZE_PER_SIDE * SIZE_PER_SIDE * floatsPerVertex;
        
       
        
        /*
         const NSString  *MV_MATRIX_UNIFORM = @"u_MVMatrix";
         const NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
         
         const NSString  *POSITION_ATTRIBUTE = @"a_Position";
         const NSString  *NORMAL_ATTRIBUTE   = @"a_Normal";
         const NSString  *COLOR_ATTRIBUTE    = @"a_Color";
         GLuint Matrix;
         GLuint modeloVista, luzPos, posicion, normalV, color;

         */
        
         NSString  *MV_MATRIX_UNIFORM = @"u_MVMatrix";
         NSString  *LIGHT_POSITION_UNIFORM = @"u_LightPos";
        
         NSString  *POSITION_ATTRIBUTE = @"a_Position";
         NSString  *NORMAL_ATTRIBUTE   = @"a_Normal";
         NSString  *COLOR_ATTRIBUTE    = @"a_Color";
        
        
        Matrix =      [self.programa getUniformParam:@"MVP"];
        modeloVista = [self.programa getUniformParam:MV_MATRIX_UNIFORM];
        luzPos =   [self.programa getUniformParam:LIGHT_POSITION_UNIFORM];
        posicion = [self.programa getParametro:POSITION_ATTRIBUTE];
        normalV =  [self.programa getParametro:NORMAL_ATTRIBUTE];
        color =    [self.programa getParametro:COLOR_ATTRIBUTE];
        
        
        
        
        const int xLength = SIZE_PER_SIDE;
        const int yLength = SIZE_PER_SIDE;
        int offset = 0;
        
        
        GLfloat vertices_map[xLength * yLength * floatsPerVertex];
        int size_map = xLength * yLength * floatsPerVertex;
        NSLog(@"size_map: %d" , size_map);
        
        
        // Loop de creacion. 
        for (int y=0; y< yLength; y++) {
            for (int x=0; x< xLength; x++) {
                float xRatio = x /  (xLength - 1);
                 // Build our heightmap from the top down, so that our triangles are
                 // counter-clockwise.
                float yRatio = 1.0f - (y / (yLength - 1));

                float xPosition = MIN_POSITION + (xRatio * POSITION_RANGE);
                float yPosition = MIN_POSITION + (yRatio * POSITION_RANGE);
                
                vertices_map[offset++] = xPosition;
                vertices_map[offset++] = yPosition;
                vertices_map[offset++] = ((xPosition * xPosition) + (yPosition * yPosition)) / 10.0f;
                
                float xSlope = (2 * xPosition) / 10.0f;
                float ySlope = (2 * yPosition) / 10.0f;
                
                float planeVectorX[] = {1.0f, 0.0f, xSlope};
                float planeVectorY[] = {0.0f, 1.0f, ySlope};
                float normalVector[] = { (planeVectorX[1] * planeVectorY[2]) - (planeVectorX[2] * planeVectorY[1]),
                                         (planeVectorX[2] * planeVectorY[0]) - (planeVectorX[0] * planeVectorY[2]),
                                         (planeVectorX[0] * planeVectorY[1]) - (planeVectorX[1] * planeVectorY[0])
                    };
                
                // Normalize the normal
              //  float length = Matrix.length(normalVector[0], normalVector[1], normalVector[2]);
                
                float length = GLKVector3Length(GLKVector3Make(normalVector[0], normalVector[1], normalVector[2]));
                
                vertices_map[offset++] = normalVector[0] / length;
                vertices_map[offset++] = normalVector[1] / length;
                vertices_map[offset++] = normalVector[2] / length;
                
                
                
                // Add some fancy colors.
                vertices_map[offset++] = xRatio;
                vertices_map[offset++] = yRatio;
                vertices_map[offset++] = 0.5f;
                vertices_map[offset++] = 1.0f;
            }
        }
        
        // Now build the index data
         int numStripsRequired = yLength - 1;
         int numDegensRequired = 2 * (numStripsRequired - 1);
         int verticesPerStrip = 2 * xLength;
        
         short mapaIndices[(verticesPerStrip * numStripsRequired) + numDegensRequired];
         offset = 0;
       
        
        for (int y = 0; y < yLength - 1; y++) {
            if (y > 0) {
                // Degenerate begin: repeat first vertex
                mapaIndices[offset++] = (short) (y * yLength);
            }
            
            for (int x = 0; x < xLength; x++) {
                // One part of the strip
                mapaIndices[offset++] = (short) ((y * yLength) + x);
                mapaIndices[offset++] = (short) (((y + 1) * yLength) + x);
            }
            
            if (y < yLength - 2) {
                // Degenerate end: repeat last vertex
                mapaIndices[offset++] = (short) (((y + 1) * yLength) + (xLength - 1));
            }
        }
        
        indices_size = sizeof(mapaIndices) / sizeof(short); 
        

        glGenBuffers(1, &_vector_buffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices_map), vertices_map, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_indices_buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(mapaIndices), mapaIndices  , GL_STATIC_DRAW);

        
    }
    
    NSLog(@"init success.");
    
    return self;
}
-(void)setRotacionx:(float)posx setRotaciony:(float)posy{
    
    // modelo = GLKMatrix4Scale(modelo, 2.0f, 2.0f, 2.0f);
    
    rotx = GLKMatrix4MakeYRotation(posx);
    modelo = GLKMatrix4Multiply(modelo, rotx);
    
    roty = GLKMatrix4MakeZRotation(posy);
    modelo = GLKMatrix4Multiply(modelo, roty);
    
        glUniform3f(luzPos,posx,posy, -8.0f);
    
}
-(void)render{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
    /*
    glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
    
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vector_buffer);
	glVertexAttribPointer(0,3, GL_FLOAT, GL_FALSE, 0, (void*) 0);
    
    
    
    
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices_buffer);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 12*3);
    glDrawElements(GL_TRIANGLES, indices_size, GL_UNSIGNED_SHORT, 0);
    glDisableVertexAttribArray(0);
     
     
     
     
     ============================= =============================
     
     Matrix =      [self.programa getParametro:@"MVP"];
     modeloVista = [self.programa getParametro:MV_MATRIX_UNIFORM];
     luzPos =   [self.programa getParametro:LIGHT_POSITION_UNIFORM];
     posicion = [self.programa getParametro:POSITION_ATTRIBUTE];
     normalV =  [self.programa getParametro:NORMAL_ATTRIBUTE];
     color =    [self.programa getParametro:COLOR_ATTRIBUTE];
     
      ============================= =============================

*/
    
    glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
    glVertexAttribPointer(posicion, POSITION_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, STRIDE, 0);
    glEnableVertexAttribArray(posicion);
    
    glVertexAttribPointer(normalV, NORMAL_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false, STRIDE, (void*)(POSITION_DATA_SIZE_IN_ELEMENTS * BYTES_PER_FLOAT));
    glEnableVertexAttribArray(normalV);
  
    
    glVertexAttribPointer(color, COLOR_DATA_SIZE_IN_ELEMENTS, GL_FLOAT, false,
                          STRIDE,(void *)((POSITION_DATA_SIZE_IN_ELEMENTS + NORMAL_DATA_SIZE_IN_ELEMENTS) * BYTES_PER_FLOAT));
    glEnableVertexAttribArray(color);
    
    //Draw
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
    glDrawElements(GL_TRIANGLE_STRIP, indices_size, GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

-(void)update{
   

    viewMatrix = GLKMatrix4MakeLookAt(0, 0, 25, 0, 0, 0, 0, 1, 0);
     
    proyecion = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0f), self.aspect, 2, -1);
    mvp = GLKMatrix4Multiply(proyecion, viewMatrix);
    
  //  glUniformMatrix4fv(modeloVista, 1, GL_FALSE, mvp.m);

    mvp = GLKMatrix4Multiply(mvp, modelo);
   
  //  glUniformMatrix4fv(Matrix, 1, GL_FALSE, mvp.m);
}
@end
