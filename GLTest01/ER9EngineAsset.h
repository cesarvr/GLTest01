//
//  ER9EngineAsset.h
//  RotationTest
//
//  Created by Cesar Luis Valdez on 26/02/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ER9EngineAsset : NSObject
{
    GLuint vTexturas, textura; //vBuffer, Matrix,
}

@property GLuint vTexturas;
@property GLuint textura;
+(GLuint)cargarTexturas;
@end
