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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _optionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"optionsTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
#warning @"Set real vehicle"
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
    
    return cell;
}

// ----------------------- Data Access Protocol messages ---------------------------

-(void)returnDataObject:(id)returnData
{
    NSDictionary* result = returnData;
    NSArray* options = [result objectForKey:@"Options"];
    _optionsList = options;
    [self.tableView reloadData];
}

-(void) showErrorMessage: (NSString *) errorMessage
{
#warning Show error message to user instead of NSLog
    NSLog(@"Error - %@", errorMessage);
    
}


@end
