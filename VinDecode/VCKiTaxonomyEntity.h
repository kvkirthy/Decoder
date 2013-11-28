//
//  VCKi.h
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCKiDataAccessProtocol.h"

@interface VCKiTaxonomyEntity : NSObject

@property NSString* OEMModelCode;
@property NSString* Trim;
@property NSString* Style;
@property NSString* StyleId;
@property id<VCKiDataAccessProtocol> caller;

-(id) initWithObject: (id)callingObject;
- (void) getTaxonomyEntitiesWithYear:(NSString*) year Make:(NSString*) make andModel:(NSString*) model;

@end
