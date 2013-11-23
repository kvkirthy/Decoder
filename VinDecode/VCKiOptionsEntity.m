//
//  VCKiOptionsEntity.m
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiOptionsEntity.h"

@implementation VCKiOptionsEntity

-(NSArray *) GetOptionsEntities
{
    NSMutableArray *entities = [[NSMutableArray alloc]init];
    
    for (int i=0; i<10; i++) {
        VCKiOptionsEntity *newObject = [[VCKiOptionsEntity alloc]init];
        newObject.OptionDescription = [NSString stringWithFormat: @" Options description %d",i ];
        [entities addObject:newObject];
    }
    
    return entities;
}

@end
