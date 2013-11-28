//
//  VCKiBarcodeViewController.h
//  VinDecode
//
//  Created by VenCKi on 10/30/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCKiDataAccessProtocol.h"

@interface VCKiBarcodeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, VCKiDataAccessProtocol >
@property UIImagePickerController* imagePicker;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPerformCameraAction;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *serviceCallStatus;
@property (weak, nonatomic) IBOutlet UITextField *textboxResult;
@property (weak, nonatomic) IBOutlet UILabel *labelYearMakeModel;
@property (weak, nonatomic) IBOutlet UIButton *buttonGoToTaxonomy;


- (IBAction)cameraLIbrarySwap:(id)sender;
- (IBAction)buttonGoToTaxonomyClick:(id)sender;
- (IBAction)useCamera:(id)sender;

// ----------------------- Data Access Protocol messages ---------------------------
// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;
// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
