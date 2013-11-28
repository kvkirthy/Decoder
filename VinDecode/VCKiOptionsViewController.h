//
//  VCKiViewController.h
//  VinDecode
//
//  Created by VenCKi on 11/24/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCKiDataAccessProtocol.h"

@interface VCKiOptionsViewController : UITableViewController<VCKiDataAccessProtocol>


// ----------------------- Data Access Protocol messages ---------------------------
// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;
// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
