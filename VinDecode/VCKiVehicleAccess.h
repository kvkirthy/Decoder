//
//  VCKiVehicleAccess.h
//  VinDecode
//
//  Created by foeteam on 11/29/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCKiDataAccessProtocol.h"


@interface VCKiVehicleAccess : NSObject

@property VCKiTaxonomyEntity* taxonomyData;
@property NSMutableArray* optionsData;
@property VCKiOptionsEntity* colorsData;
@property VCKiVehicleBasicDataEntity* vehBasicData;
@property id<VCKiDataAccessProtocol> caller;

-(id) initWithObject: (id)callingObject;
-(BOOL) createVehicle;

@end
