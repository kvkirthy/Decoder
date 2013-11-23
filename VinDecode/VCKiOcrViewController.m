//
//  VCKiViewController.m
//  VinDecode
//
//  Created by VenCKi on 10/27/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiOcrViewController.h"

@interface VCKiOcrViewController ()

@end

@implementation VCKiOcrViewController

//@synthesize imagePicker = _imagePicker;
@synthesize imageView = _imageView;


- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagePicker = [[UIImagePickerController alloc]init];
	self.imagePicker.delegate = self;
    
    self.textboxResult.delegate = self;
    
     [self.buttonPerformCameraAction setTitle:@"Unavilable" forState:UIControlStateDisabled];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        self.buttonPerformCameraAction.enabled = NO;
    }
    
    [self registerDefaultsFromSettingsBundle];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textboxResult resignFirstResponder];
    return YES;
}


-(void) postOcrData: (NSData *) imageData and: (NSString *) postData
{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@/%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"ocrApiPostfix"]];
        
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"-----------------------------7dd38a1060692";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request addValue:@"text/html, application/xhtml+xml, */*" forHTTPHeaderField:@"Accept"];
        [request addValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\nContent-Disposition: form-data; name=\"caption\"" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat: @"\r\n\r\n%@",postData] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\nContent-Disposition: form-data; name=\"image1\"; filename=\"ipodfile.png\""dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\nContent-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n-------------------------------7dd38a1060692--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                
                if (data.length > 0 && !connectionError) {
                    if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                        [self.textboxResult setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                    }
                    else{
                        @throw [NSException exceptionWithName:@"ServerError" reason:[NSString stringWithFormat:@"Status code from server is %ld", (long)[(NSHTTPURLResponse *)response statusCode]]  userInfo:nil];
                    }
                }
                else if(connectionError){
                    @throw [NSException exceptionWithName:@"ConnectionError" reason:[NSString stringWithFormat:@"%@", connectionError]  userInfo:nil];
                }
                else
                {
                    @throw [NSException exceptionWithName:@"UnknownError" reason:@"Invalid Response" userInfo:nil];
                }
            }
            @catch (NSException *exception) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Gosh Error!" message:@"Error while trying to decode" delegate:nil cancelButtonTitle:@"Okay !" otherButtonTitles:nil];
                [alert show];
            }
            @finally {
                [self.serviceCallStatus stopAnimating];
            }
            
            
        }];
}



- (IBAction)useCamera:(id)sender {
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try{
        _imageView.image = info[UIImagePickerControllerOriginalImage];
        [self postOcrData: UIImageJPEGRepresentation(_imageView.image, 1.0) and:@"ocr image"];
        [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
        [self.serviceCallStatus startAnimating];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Gosh Error!" message:@"Error while trying to decode" delegate:nil cancelButtonTitle:@"Got It!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraLIbrarySwap:(id)sender {
    if ([self.segmentControl selectedSegmentIndex] == 0){
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

- (IBAction)buttonGoToTaxonomyClick:(id)sender {
    [self performSegueWithIdentifier:@"segueToTaxonomy1" sender:self];
}
@end
