//
//  ER9Modelo.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 11/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9Modelo.h"

@implementation ER9Modelo

- (id)init
{
    self = [super init];
    if (self) {
        _normales = [[NSMutableArray alloc]init];
        _posiciones = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
