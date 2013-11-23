//
//  VCKi.m
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiTaxonomyEntity.h"

@implementation VCKiTaxonomyEntity

-(NSArray*)getTaxonomyEntities
{
    NSMutableArray *entities = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        VCKiTaxonomyEntity *newObject = [[VCKiTaxonomyEntity alloc]init];
        newObject.OEMModelCode = [NSString stringWithFormat: @" OEM Model Code %d",i ];
        newObject.Style = [NSString stringWithFormat: @" Style Code %d",i ];
        newObject.Trim = [NSString stringWithFormat: @" Trim Code %d",i ];
        [entities addObject:newObject];
    }
    
    return entities;
}

@end
