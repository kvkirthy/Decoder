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

@interface VCKiConfirmScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property VCKiVehicleBasicDataEntity *basicVehicleData;
@property VCKiTaxonomyEntity *taxonomyData;
@property NSArray *optionsData;
@property VCKiOptionsEntity *colorsdata;

@end
