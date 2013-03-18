//
//  ER9Asset.h
//  GLTest01
//
//  Created by Cesar Luis Valdez on 08/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ER9Vertices.h"


@interface ER9Asset : NSObject
{

}



@property (strong, nonatomic)NSMutableArray *vposiciones;
@property (strong, nonatomic)NSMutableArray *indices;


@property GLuint vTexturas;
@property GLuint textura;
+(GLuint)cargarTexturas;
-(void) cargarModelo;

@end
