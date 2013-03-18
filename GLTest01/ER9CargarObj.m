//
//  ER9CargarObj.m
//  GLTest01
//
//  Created by Cesar Luis Valdez on 11/03/13.
//  Copyright (c) 2013 Cesar Luis Valdez. All rights reserved.
//

#import "ER9CargarObj.h"

@implementation ER9CargarObj



- (id)init
{
    self = [super init];
    if (self) {
        [self cargarModelo];
    }
    return self;
}

-(ER9Modelo *)modelo{

    if (!_modelo) {
        _modelo = [[ER9Modelo alloc]init];
    }

    return _modelo; 
}

-(void)cargarModelo{
    
    NSString *rutaImagen = [[NSBundle mainBundle] pathForResource:@"donut3" ofType:@"obj"];
    NSString *fichero = [NSString stringWithContentsOfFile:rutaImagen encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *array_position = [[NSMutableArray alloc]initWithCapacity:5];
    NSMutableArray *array_normales = [[NSMutableArray alloc]initWithCapacity:5];
    NSMutableArray *array_indices = [[NSMutableArray alloc]initWithCapacity:5];
    
    
    for (NSString *line in [fichero componentsSeparatedByString:@"\n"]) {
        
        if ([line hasPrefix:@"v"]) {
            
            NSArray *vertices = [line componentsSeparatedByString:@" "];
            ER9Vertices *triangulos = [[ER9Vertices alloc]init];
            [triangulos setX:[vertices[1] floatValue]];
            [triangulos setY:[vertices[2] floatValue]];
            [triangulos setZ:[vertices[3] floatValue]];
            
            [array_position addObject:triangulos];
        }
        
        if ([line hasPrefix:@"vn"]) {
            
            NSArray *vertices = [line componentsSeparatedByString:@" "];
            ER9Vertices *triangulos = [[ER9Vertices alloc]init];
            [triangulos setNx:[vertices[1] floatValue]];
            [triangulos setNy:[vertices[2] floatValue]];
            [triangulos setNz:[vertices[3] floatValue]];
            
            [array_normales addObject:triangulos];
        }
        
        
        if ([line hasPrefix:@"f"]) {
            
            NSArray *vertices = [line componentsSeparatedByString:@" "];
            
            for (NSString *indices in vertices)
                if (![indices isEqual: @"f"] && ![indices isEqual: @""]){
                    NSArray *piezas = [indices componentsSeparatedByString:@"/"];
                    ER9Vertices *triangulos = [[ER9Vertices alloc]init];
                    [triangulos setIvertex:[[piezas objectAtIndex:0] intValue]];
                    [triangulos setInormals:[[piezas objectAtIndex:2] intValue]];
                    [array_indices addObject:triangulos];
                }
            
                    
        }
        
                 
    }
    
    
    
    for (ER9Vertices *info in array_indices) {
        short index =  info.ivertex;
        short normalx = info.inormals;
        
        ER9Vertices *o_posicion =  [array_position objectAtIndex:(index-1)];
        [self addPosiciones:o_posicion];
        
        if([array_normales count]>0){
            ER9Vertices *o_normals =  [array_normales objectAtIndex:(normalx-1)];
            [self addNormales:o_normals];
        }
    }
    
    
    
    
    
       
}

-(void)addPosiciones:(ER9Vertices *)posiciones{
    
    [self.modelo.posiciones addObject:[NSNumber numberWithFloat:posiciones.x]];
    [self.modelo.posiciones addObject:[NSNumber numberWithFloat:posiciones.y]];
    [self.modelo.posiciones addObject:[NSNumber numberWithFloat:posiciones.z]];

}

-(void)addNormales:(ER9Vertices *)posiciones{
    
    [self.modelo.normales addObject:[NSNumber numberWithFloat:posiciones.nx]];
    [self.modelo.normales addObject:[NSNumber numberWithFloat:posiciones.ny]];
    [self.modelo.normales addObject:[NSNumber numberWithFloat:posiciones.nz]];
    
}

/*
-(void)addVertices:(GLKVector3)vertice addNormales:(GLKVector3)normales{
    
    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.x]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.y]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:vertice.z]];
    
    
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.x]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.y]];
    [self.vposiciones addObject:[NSNumber numberWithFloat:normales.z]];
}
*/


@end
