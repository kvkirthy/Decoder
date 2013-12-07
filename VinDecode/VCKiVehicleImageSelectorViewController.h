//
//  VCKiVehicleImageSelectorViewController.h
//  VinDecode
//
//  Created by foeteam on 12/5/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCKiDataAccessProtocol.h"
#import "VCKiControllerDataExchange.h"

@interface VCKiVehicleImageSelectorViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VCKiDataAccessProtocol>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPerformCameraAction;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraPicLibSelector;
@property UIImagePickerController* imagePicker;
@property id<VCKiControllerDataExchange> delegate;

- (IBAction)picSelectorClicked:(id)sender;
- (IBAction)swapCameraSelection:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageUploadActivity;

// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;

// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
