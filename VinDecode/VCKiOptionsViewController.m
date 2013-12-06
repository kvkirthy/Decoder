//
//  VCKiViewController.m
//  VinDecode
//
//  Created by VenCKi on 11/24/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiOptionsViewController.h"
#import "VCKiOptionsEntity.h"
#import "VCKiVehicleBasicDataEntity.h"
#import "VCKiTaxonomyEntity.h"
#import "VCKiConfirmScreenViewController.h"

@interface VCKiOptionsViewController ()

@end

@implementation VCKiOptionsViewController

NSArray* _optionsList;
NSMutableArray* _optionsEntityList;
NSArray* _colorsList;
NSMutableArray* _colorsEntityList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[VCKiOptionsEntity alloc]initWithObject:self] GetOptionsEntitiesForStyleId:_taxonomyEntity.StyleId];
    _optionsEntityList = [[NSMutableArray alloc]init];
    _colorsEntityList =[[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return _optionsList.count;
    }
    else{
        return _colorsList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"optionsTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    VCKiOptionsEntity* optionEntity = [[VCKiOptionsEntity alloc]init];
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", _vehicleBasicData.make, _vehicleBasicData.model ];
        cell.detailTextLabel.text= [NSString stringWithFormat:@"%@",_vehicleBasicData.year];
    }
    else if(indexPath.section == 1)
    {
        NSDictionary *entity = [_optionsList objectAtIndex:indexPath.row];
        
        optionEntity.OptionDescription = [entity objectForKey:@"Description"];;
        optionEntity.OptionCode =[entity objectForKey:@"OptionCode"];
        
        [_optionsEntityList addObject: optionEntity];
        
        if(optionEntity.OptionDescription){
            cell.textLabel.text = optionEntity.OptionDescription;
            cell.detailTextLabel.text = optionEntity.OptionCode;
        }
        else
        {
            cell.textLabel.text = @"Invalid Description";
            cell.detailTextLabel.text = @"";
        }
        
    }
    else if(indexPath.section == 2)
    {
        NSDictionary *entity = [_colorsList objectAtIndex:indexPath.row];
        
        NSDictionary* externalColor =[entity objectForKey:@"ExternalColor"];
        NSArray* internalColorArray =[entity objectForKey:@"InternalColor"];
        NSDictionary* internalColor = [internalColorArray objectAtIndex:0];
        
        if(externalColor){
            optionEntity.ExternalColorName = [externalColor objectForKey:@"Name"];
            optionEntity.ExternalColorCode = [externalColor objectForKey:@"Code"];
            optionEntity.ExternalRgbHexCode = [externalColor objectForKey:@"RgbHexCode"];
        }
        
        if (internalColor) {
            optionEntity.InternalColorName = [internalColor objectForKey:@"Name"];
            optionEntity.InternalColorCode = [internalColor objectForKey:@"Code"];
        }
        
        [_colorsEntityList addObject:optionEntity];
        
        if(optionEntity.ExternalColorName &&  optionEntity.InternalColorName){
            cell.textLabel.text = optionEntity.ExternalColorName;
            cell.detailTextLabel.text = optionEntity.InternalColorName;
        }
        else
        {
            cell.textLabel.text = @"Invalid color";
            cell.detailTextLabel.text = @"";
        }
        
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
            sectionName = @"Select one or more options";
            break;
        case 2:
            sectionName = @"Select colors";
            break;
    }
    return sectionName;
}


// ----------------------- Data Access Protocol messages ---------------------------

-(void)returnDataObject:(id)returnData
{
    NSDictionary* result = returnData;
    _optionsList = [result objectForKey:@"Options"];;
    _colorsList = [result objectForKey:@"Colors"];
    [self.tableView reloadData];
}

-(void) showErrorMessage: (NSString *) errorMessage
{
    [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error returned %@.",errorMessage ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray* selectedRows = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedOptions = [[NSMutableArray alloc]init];
    VCKiOptionsEntity   *selectedColor = [[VCKiOptionsEntity alloc]init];
    
    for(int i=0; i<[selectedRows count]; i++)
    {
        NSIndexPath* indexPath = [selectedRows objectAtIndex:i];
        if(indexPath.section == 1){
            NSLog(@"%d", indexPath.row);
            [selectedOptions addObject:[_optionsEntityList objectAtIndex:indexPath.row]];
        }
        else if(indexPath.section == 2){
            NSLog(@"%d", indexPath.row);
#warning Makesure there is only one color selected.
            selectedColor =[_colorsEntityList objectAtIndex:indexPath.row];
        }
    }
    
    VCKiConfirmScreenViewController *scene = [segue destinationViewController];
    scene.basicVehicleData = self.vehicleBasicData;
    scene.taxonomyData = self.taxonomyEntity;
    scene.optionsData = [[NSMutableArray alloc]initWithArray: selectedOptions];
    scene.colorsdata = selectedColor;
}

@end
