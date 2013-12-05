//
//  VCKiVehicleImageSelectorViewController.m
//  VinDecode
//
//  Created by foeteam on 12/5/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiVehicleImageSelectorViewController.h"
#import "VCKiVehicleAccess.h"

@interface VCKiVehicleImageSelectorViewController ()
@property VCKiVehicleAccess* vehicleAccess;
@end

@implementation VCKiVehicleImageSelectorViewController

int _imageCount = 1, _previousYPosition = 1, _previousXPosition = 1;

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
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.vehicleAccess = [[VCKiVehicleAccess alloc]initWithObject:self];
	self.imagePicker.delegate = self;
    
    [self.buttonPerformCameraAction setTitle:@"Unavilable" forState:UIControlStateDisabled];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        self.buttonPerformCameraAction.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try{
        int offset = 120;
        UIImage* image = info[UIImagePickerControllerOriginalImage];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
#warning Need to adjust by image dimentions. Need this code to be better.
        imageView.frame = CGRectMake(_previousXPosition,_previousYPosition,offset,offset);
        if(_imageCount % 2 != 0)
        {
            _previousXPosition = offset + 5;
        }
        else
        {
            _previousXPosition = 5;
            _previousYPosition += offset + 5;
        }
        
        [self.scrollView addSubview:imageView];
        [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
        _imageCount += 1;
        
        [self.vehicleAccess postVehicleImage:UIImageJPEGRepresentation(imageView.image, 1.0) and:@"image"];
        
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Gosh Error!" message:@"Error while trying to upload image" delegate:nil cancelButtonTitle:@"Got It!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)picSelectorClicked:(id)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)swapCameraSelection:(id)sender {
    @try {
        if ([self.cameraPicLibSelector selectedSegmentIndex] == 0){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.buttonPerformCameraAction.enabled = YES;
                [self.buttonPerformCameraAction setTitle:@"Tap to start camera" forState:UIControlStateNormal];
                
            }
            else{
                self.buttonPerformCameraAction.enabled = NO;
            }
            
        }
        else
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.buttonPerformCameraAction.enabled = YES;
                [self.buttonPerformCameraAction setTitle:@"Tap to go to Photo Library" forState:UIControlStateNormal];
            }
            else{
                self.buttonPerformCameraAction.enabled = NO;
            }
        }
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error while attempting to load camera/library view. %@",exception ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    }

}
// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData
{
    [self.delegate setStringData:[NSString stringWithFormat:@"%@",[returnData stringValue]]];
#warning Incomplete implementation
    
}

// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage
{
#warning incomplete implementation
    NSLog(@"error %@", errorMessage);
}

@end
