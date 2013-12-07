//
//  VCKiBarcodeViewController.m
//  VinDecode
//
//  Created by VenCKi on 10/30/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiBarcodeViewController.h"
#import "VCKiVehicleBasicDataEntity.h"
#import "VCKiTaxonomyViewController.h"

@interface VCKiBarcodeViewController ()

@end

@implementation VCKiBarcodeViewController

VCKiVehicleBasicDataEntity *vehicle;

//@synthesize imagePicker = _imagePicker;
@synthesize imageView = _imageView;
VCKiVehicleBasicDataEntity *basicDataAccess;

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
    @try {
        [super viewDidLoad];
        [self registerDefaultsFromSettingsBundle];
        [self.serviceCallStatus stopAnimating];
        
        self.barcodeReader = [ZBarReaderController new];
        self.barcodeReader.delegate = self;
        self.textboxResult.delegate = self;
        self.textStockNumber.delegate = self;
        
        vehicle = [[VCKiVehicleBasicDataEntity alloc]init];
        
        [self.buttonPerformCameraAction setTitle:@"Unavilable" forState:UIControlStateDisabled];
        
        if([ZBarReaderController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera])
        {
            self.barcodeReader.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            self.buttonPerformCameraAction.enabled = NO;
        }
        
        basicDataAccess = [[VCKiVehicleBasicDataEntity alloc]initWithObject:self];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error while loading the view %@",exception ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textboxResult resignFirstResponder];
    [self.textStockNumber resignFirstResponder];
    return YES;
}

- (IBAction)useCamera:(id)sender {
    self.textControlsSection.hidden = YES;

    ZBarImageScanner *scanner = self.barcodeReader.scanner;
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:self.barcodeReader animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try{
        
        id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        
        // first available barcode value is fine. Only one bar code expected.
        for(symbol in results)
            break;
        
        vehicle.vin = symbol.data;
        [self.textboxResult setText:vehicle.vin];
        self.textControlsSection.hidden = NO;
        //[self.serviceCallStatus stopAnimating];
        
        _imageView.image = info[UIImagePickerControllerOriginalImage];
        [self.barcodeReader dismissViewControllerAnimated:YES completion:nil];
        //[self.serviceCallStatus startAnimating];
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Gosh Error!" message:@"Error while trying to decode" delegate:nil cancelButtonTitle:@"Got It!" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.barcodeReader dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraLIbrarySwap:(id)sender {
    @try {
        if ([self.segmentControl selectedSegmentIndex] == 0){
            
            if([ZBarReaderController isSourceTypeAvailable:
                UIImagePickerControllerSourceTypeCamera])
            {
                self.barcodeReader.sourceType = UIImagePickerControllerSourceTypeCamera;
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
                self.barcodeReader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    @try {
        
        [_serviceCallStatus stopAnimating];
        VCKiVehicleBasicDataEntity* lVehicle = (VCKiVehicleBasicDataEntity *)returnData;
        vehicle.year = lVehicle.year;
        vehicle.make = lVehicle.make;
        vehicle.makeId = lVehicle.makeId;
        vehicle.modelId = lVehicle.modelId;
        
        vehicle.model = lVehicle.model;
        
        self.labelYearMakeModel.text = [NSString stringWithFormat:@"%@ - %@ - %@",vehicle.year, vehicle.make, vehicle.model ];
        [self performSegueWithIdentifier:@"segueToTaxonomy2" sender:self];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Couldn't use returned data. %@",exception ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    }
   
    
}

// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage
{
    [_serviceCallStatus stopAnimating];

    [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error returned %@.",errorMessage ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    
}

- (IBAction)buttonGoToTaxonomyClick:(id)sender {
    @try {
        vehicle.vin = self.textboxResult.text;
        vehicle.stockNumber = _textStockNumber.text;
        [self.serviceCallStatus startAnimating];
        [basicDataAccess getVehicleBasicDataForVin:vehicle.vin];

    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error attempting to navigate to the next view %@.",exception ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        
        if(vehicle)
        {
            VCKiTaxonomyViewController *taxonomyVC = [segue destinationViewController];
            vehicle.stockNumber = self.textStockNumber.text;
        
            taxonomyVC.vehicleData = vehicle;
        }
    
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc]initWithTitle:@"Gosh, Error" message:[NSString stringWithFormat:@"Error attempting to navigate to the next view %@.",exception ] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil] show];
    }
}

@end
