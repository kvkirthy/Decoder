//
//  VCKiVehicleImageSelectorViewController.h
//  VinDecode
//
//  Created by foeteam on 12/5/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCKiVehicleImageSelectorViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPerformCameraAction;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraPicLibSelector;
@property UIImagePickerController* imagePicker;

- (IBAction)picSelectorClicked:(id)sender;
- (IBAction)swapCameraSelection:(id)sender;
@end
