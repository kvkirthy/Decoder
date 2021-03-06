//
//  VCKiVehicleAccess.h
//  VinDecode
//
//  Created by foeteam on 11/29/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCKiDataAccessProtocol.h"
#import "VCKiOptionsEntity.h"
#import "VCKiTaxonomyEntity.h"
#import "VCKiVehicleBasicDataEntity.h"


@interface VCKiVehicleAccess : NSObject

@property VCKiTaxonomyEntity* taxonomyData;
@property NSMutableArray* optionsData;
@property VCKiOptionsEntity* colorsData;
@property VCKiVehicleBasicDataEntity* vehBasicData;
@property id<VCKiDataAccessProtocol> caller;

-(void) postVehicleImage: (NSData *) imageData and: (NSString *)postData;
-(id) initWithObject: (id)callingObject;
-(BOOL) createVehicle;

@end
