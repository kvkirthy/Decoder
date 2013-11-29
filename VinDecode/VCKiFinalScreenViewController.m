//
//  VCKiFinalScreenViewController.m
//  VinDecode
//
//  Created by foeteam on 11/29/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiFinalScreenViewController.h"

@interface VCKiFinalScreenViewController ()

@end

@implementation VCKiFinalScreenViewController

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
	[self.statusMessage setText:self.message];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
