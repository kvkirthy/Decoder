//
//  VCKiVehicleBasicDataEntity.m
//  VinDecode
//
//  Created by foeteam on 11/27/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiVehicleBasicDataEntity.h"

@implementation VCKiVehicleBasicDataEntity

NSMutableData *receivedData;

-(id)initWithObject:(id)callingObject
{
    self.caller = callingObject;
    receivedData = [[NSMutableData alloc]init];
    return self;
}

-(void) getVehicleBasicDataForVin:(NSString *)vin
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?vin=%@&json=true",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"vehicleDataApi"],vin];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if(urlConnection )
    {
        if(receivedData)
        {
            [receivedData setLength:0];
        }
        else
        {
            receivedData = [NSMutableData data];
        }
    }
    else{
        [self.caller showErrorMessage: @"Error connecting"];
    }
}

// Rest of the code is callback message from network operations.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.caller showErrorMessage:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
                                     [error localizedDescription],
                                     [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try {
        
       // NSMutableArray *returnData = [[NSMutableArray alloc]init];
        
        BOOL isResponseValid = NO;
        
        NSError *error = nil;
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
        

            
            VCKiVehicleBasicDataEntity *vehicle = [[VCKiVehicleBasicDataEntity alloc]init];
            vehicle.year = [res objectForKey:@"Year"];
            vehicle.make = [res objectForKey:@"Make"];
            vehicle.model = [res objectForKey:@"Model"];
            
            
            isResponseValid = YES;
            
           // [returnData addObject:vehicle];
  
        
        if (isResponseValid) {
            [self.caller returnDataObject:vehicle];
        }
        else{
            [self.caller showErrorMessage: @"Invalid response."];
        }
        
    }
    @catch (NSException *exception) {
        [self.caller showErrorMessage: [NSString stringWithFormat:@"Error from the service %@", exception]];
    }
}


@end
