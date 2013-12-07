//
//  VCKiFinalScreenViewController.h
//  VinDecode
//
//  Created by foeteam on 11/29/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface VCKiFinalScreenViewController : UIViewController<UIActionSheetDelegate>

@property NSString* message;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
- (IBAction)goSocialClicked:(id)sender;
- (IBAction)parkButtonClicked:(id)sender;

@end
