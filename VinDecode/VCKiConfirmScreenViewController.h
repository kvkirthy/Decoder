//
//  VCKiConfirmScreenViewController.h
//  VinDecode
//
//  Created by foeteam on 11/28/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCKiVehicleBasicDataEntity.h"
#import "VCKiTaxonomyEntity.h"
#import "VCKiOptionsEntity.h"


@interface VCKiConfirmScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, VCKiDataAccessProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property VCKiVehicleBasicDataEntity *basicVehicleData;
@property VCKiTaxonomyEntity *taxonomyData;
@property NSMutableArray *optionsData;
@property VCKiOptionsEntity *colorsdata;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *createActivity;
@property (weak, nonatomic) IBOutlet UIButton *buttonCreateVehicle;

- (IBAction)buttonCreateNewClicked:(id)sender;

// ----------------------- Data Access Protocol messages ---------------------------
// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;
// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
