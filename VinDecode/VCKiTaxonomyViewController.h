//
//  VCKiTaxonomyViewController.h
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCKiDataAccessProtocol.h"
#import "VCKiVehicleBasicDataEntity.h"

@interface VCKiTaxonomyViewController : UITableViewController <VCKiDataAccessProtocol>

@property NSString* vehicleTitle;
@property VCKiVehicleBasicDataEntity *vehicleData;

// ----------------------- Data Access Protocol messages ---------------------------
// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;
// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
