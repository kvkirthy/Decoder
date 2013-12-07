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

- (IBAction)goSocialClicked:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Go Social" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)parkButtonClicked:(id)sender {
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex ==0 )
    {
        SLComposeViewController* social = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [social setInitialText:[NSString stringWithFormat:@"%@ %@", @"Exciting Stuff!", self.message]];
        
        [self presentViewController:social animated:YES completion:nil];
    }
    
    if(buttonIndex ==1 )
    {
        SLComposeViewController* social = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [social setInitialText:[NSString stringWithFormat:@"%@ %@", @"Exciting Stuff!", self.message]];
        [self presentViewController:social animated:YES completion:nil];
    }
    
}

@end
