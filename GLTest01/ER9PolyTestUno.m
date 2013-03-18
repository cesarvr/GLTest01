//
//  ER9PolyTestUno.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 05/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9PolyTestUno.h"

@implementation ER9PolyTestUno


- (id)init
{
    self = [super init];
    if (self) {
      
        /*
        static const GLfloat vertices_old[] = {
        -1.0f, -1.0f, 0.0f,
         0.0f, -1.0f, 1.0f,
         1.0f, -1.0f, 0.0f,
         0.0f,  1.0f, 0.0f
        };
        */
        
        
        
        
        //static const unsigned short indices_old[] = {0, 3, 1};
    
    
        /*
         
         { 5.0f,-5.0f,  0.0f, 1.0f,
          -5.0f,-5.0f,  0.0f, 1.0f,
           5.0f, 5.0f,  0.0f, 1.0f,
          -5.0f, 5.0f,  0.0f, 1.0f,
         1.0f, 0.0f,  0.0f, 1.0f,
         0.0f, 1.0f,  0.0f, 1.0f,
         0.0f, 0.0f,  1.0f, 1.0f };
         */
        
        static const GLfloat vertices[] = {
             1.0f,-1.0f, 0.0f, //der      indices : 0,1,2,3
            -1.0f,-1.0f, 0.0f, //izq
             1.0f, 1.0f, 0.0f, //top der
            -1.0f, 1.0f, 0.0f, //top izq
            
            1.0f,-1.0f, 1.0f,  //der            4,5,6,7
            -1.0f,-1.0f,1.0f,  //izq
            1.0f, 1.0f, 1.0f,  //top der
            -1.0f, 1.0f,1.0f,}; // top izq

        
        static const unsigned short indices[] = {0, 1, 2,
                                                 2, 3, 1,
            
                                                 0,1,4, 4,1,5,  //bottom
                                                 4,5,6, 6,7,5,  //otra cara
                                                 2,3,6, 6,7,3
        };                  
        
        glGenBuffers(1, &_vector_buffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vector_buffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
        glGenBuffers(1, &_indices_buffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indices_buffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
        
        _indice_size = sizeof(indices)/sizeof(short);
    }
    
    
    
    return self;
}

@end
