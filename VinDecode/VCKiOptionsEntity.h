//
//  VCKiOptionsEntity.h
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCKiDataAccessProtocol.h"

@interface VCKiOptionsEntity : NSObject

@property NSString *OptionDescription;
@property id<VCKiDataAccessProtocol> caller;

-(id) initWithObject: (id)callingObject;
-(void) GetOptionsEntitiesForStyleId: (NSString *) styleId;


@end
