//
//  VCKiViewController.h
//  VinDecode
//
//  Created by VenCKi on 10/27/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCKiOcrViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate >
@property UIImagePickerController* imagePicker;
- (IBAction)useCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPerformCameraAction;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *serviceCallStatus;
- (IBAction)cameraLIbrarySwap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textboxResult;
- (IBAction)buttonGoToTaxonomyClick:(id)sender;

@end
