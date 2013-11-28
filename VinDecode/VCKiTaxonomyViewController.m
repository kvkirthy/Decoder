//
//  VCKiTaxonomyViewController.m
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiTaxonomyViewController.h"
#import "VCKiTaxonomyEntity.h"
#import "VCKiOptionsViewController.h"

@interface VCKiTaxonomyViewController ()

@end

@implementation VCKiTaxonomyViewController

BOOL isSegueAllowed;
NSArray *_taxonomyRecords;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[VCKiTaxonomyEntity alloc]initWithObject:self] getTaxonomyEntitiesWithYear:_vehicleData.year  Make:_vehicleData.make andModel:_vehicleData.model];
    isSegueAllowed = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return _taxonomyRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taxonomyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        
        VCKiTaxonomyEntity* entity = [_taxonomyRecords objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", entity.Trim, entity.Style ];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", entity.OEMModelCode ];
        //cell.title.text =
    }
    else if(indexPath.section == 0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _vehicleData.make, _vehicleData.model ];
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%@",_vehicleData.year];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"About Vehicle,";
            break;
        case 1:
            sectionName = @"Select Style, Trim & OEM Code";
            break;
      
           }
    return sectionName;
}

-(void)returnDataObject:(id)returnData
{
    _taxonomyRecords = returnData;
    [self.tableView reloadData];
}

-(void) showErrorMessage: (NSString *) errorMessage
{
#warning Show error message to user instead of NSLog
    NSLog(@"Error - %@", errorMessage);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    UITableViewCell *cell = sender;
    if([cell.detailTextLabel.text  isEqual: @""]){
        return NO;
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VCKiTaxonomyEntity* taxonomyObject= [_taxonomyRecords objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    VCKiOptionsViewController* optionsVC = [segue destinationViewController];
    optionsVC.vehicleBasicData = self.vehicleData;
    optionsVC.taxonomyEntity = taxonomyObject;
}

@end
