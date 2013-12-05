//
//  VCKiVehicleBasicDataEntity.h
//  VinDecode
//
//  Created by foeteam on 11/27/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCKiDataAccessProtocol.h"

@interface VCKiVehicleBasicDataEntity : NSObject

@property NSString* vin;
@property NSString* year;
@property NSString* make;
@property NSString* makeId;
@property NSString* model;
@property NSString* modelId;
@property NSString* stockNumber;
@property NSMutableArray* images;

@property id<VCKiDataAccessProtocol> caller;

-(id) initWithObject: (id)callingObject;
-(void) getVehicleBasicDataForVin: (NSString*) vin;

@end
