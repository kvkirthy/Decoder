//
//  VCKiConfirmScreenViewController.m
//  VinDecode
//
//  Created by foeteam on 11/28/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiConfirmScreenViewController.h"
#import "VCKiVehicleAccess.h"
#import "VCKiFinalScreenViewController.h"

@interface VCKiConfirmScreenViewController ()

@end

@implementation VCKiConfirmScreenViewController

NSString* finalMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //finalMessage = [[NSString alloc]init]
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.createActivity stopAnimating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return _optionsData.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"confirmCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", _basicVehicleData.make, _basicVehicleData.model, _basicVehicleData.year ];
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%@ - %@", _basicVehicleData.vin, _basicVehicleData.stockNumber];
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _taxonomyData.Style, _taxonomyData.OEMModelCode ];
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%@",_taxonomyData.Trim];
        
    }
    else if(indexPath.section == 2)
    {
        VCKiOptionsEntity* optionEntity = [_optionsData objectAtIndex:indexPath.row];
        cell.textLabel.text = optionEntity.OptionDescription;
        cell.detailTextLabel.text = optionEntity.OptionCode;
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _colorsdata.ExternalColorName];
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%@", _colorsdata.InternalColorName];

    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Vehicle";
            break;
        case 1:
            sectionName = @"Trim/Style/OEM";
            break;
        case 2:
            sectionName = @"Options";
            break;
        case 3:
            sectionName = @"Colors";
    }
    return sectionName;
}

-(void)returnDataObject:(id)returnData
{
    finalMessage = returnData;
    self.buttonCreateVehicle.hidden = YES;
    [self performSegueWithIdentifier:@"segueToFinalScreen" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.createActivity stopAnimating];
    VCKiFinalScreenViewController *screen = [segue destinationViewController];
    screen.message =  [NSString stringWithFormat:@"%@. (%@) %@ %@.",finalMessage, _basicVehicleData.year, _basicVehicleData.make, _basicVehicleData.model];
}


-(void) showErrorMessage: (NSString *) errorMessage
{
    [self.createActivity stopAnimating];
    [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error returned %@.",errorMessage ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonCreateNewClicked:(id)sender {
    self.createActivity.hidden = NO;
    [self.createActivity startAnimating];
   VCKiVehicleAccess *vehicle = [[VCKiVehicleAccess alloc]initWithObject:self];
    vehicle.vehBasicData = _basicVehicleData;
    vehicle.taxonomyData = _taxonomyData;
    vehicle.colorsData = _colorsdata;
    vehicle.optionsData = _optionsData;
    [vehicle createVehicle];
}

@end
