//
//  VCKiViewController.m
//  VinDecode
//
//  Created by VenCKi on 11/24/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiOptionsViewController.h"
#import "VCKiOptionsEntity.h"

@interface VCKiOptionsViewController ()

@end

@implementation VCKiOptionsViewController

NSArray* _optionsList;
NSArray* _colorsList;

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
    
    [[[VCKiOptionsEntity alloc]initWithObject:self] GetOptionsEntitiesForStyleId:_styleId];
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
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = self.vehicleTitle;
    }
    else if(indexPath.section == 1)
    {
        NSDictionary *entity = [_optionsList objectAtIndex:indexPath.row];
        NSString* description =[entity objectForKey:@"Description"];
        if(description){
            cell.textLabel.text = description;
        }
        else
        {
            cell.textLabel.text = @"Invalid Description";
        }
        
    }
    else if(indexPath.section == 2)
    {
        NSDictionary *entity = [_colorsList objectAtIndex:indexPath.row];
        NSDictionary* externalColor =[entity objectForKey:@"ExternalColor"];
        NSString* description = [externalColor objectForKey:@"Name"];
        if(description){
            cell.textLabel.text = description;
        }
        else
        {
            cell.textLabel.text = @"Invalid color";
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
            // ...
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
#warning Show error message to user instead of NSLog
    NSLog(@"Error - %@", errorMessage);
    
}


@end
