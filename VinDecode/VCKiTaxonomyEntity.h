//
//  VCKi.h
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCKiTaxonomyEntity : NSObject

@property NSString* OEMModelCode;
@property NSString* Trim;
@property NSString* Style;

- (NSArray*) getTaxonomyEntities;

@end
