//
//  ER9Vertices.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 09/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface ER9Vertices : NSObject


@property (strong, nonatomic) NSMutableArray *posiciones;
@property GLfloat x,y,z;
@property GLfloat nx,ny,nz;
@property short ivertex , inormals; 
@end
