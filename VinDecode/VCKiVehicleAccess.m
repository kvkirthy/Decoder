//
//  VCKiVehicleAccess.m
//  VinDecode
//
//  Created by foeteam on 11/29/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiTaxonomyEntity.h"
#import "VCKiOptionsEntity.h"
#import "VCKiVehicleBasicDataEntity.h"

#import "VCKiVehicleAccess.h"

@implementation VCKiVehicleAccess

NSMutableData *receivedData;

-(id)initWithObject:(id)callingObject
{
    self.caller = callingObject;
    receivedData = [[NSMutableData alloc]init];
    return self;
}

-(BOOL) createVehicle
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?json=true",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"vehicleDataApi"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  
    NSString* requestObject = [NSString stringWithFormat:@"{Vin: \"%@\", StockNumber: \"%@\", Year: \"%@\", MakeId: \"%@\", ModelId: \"%@\", Model: \"%@\", Trim: \"%@\", StyleId: \"%@\", Style: \"%@\", OEMCode: \"%@\", Options:null, ExternalColor: {Code:\"%@\", Name: \"%@\", RgbHexCode: \"%@\"}, InternalColor: {Code:\"%@\", Name: \"%@\"}}", _vehBasicData.vin, _vehBasicData.stockNumber, _vehBasicData.year, _vehBasicData.makeId, _vehBasicData.modelId, _vehBasicData.model, _taxonomyData.Trim, _taxonomyData.StyleId, _taxonomyData.Style, _taxonomyData.OEMModelCode, _colorsData.ExternalColorCode, _colorsData.ExternalColorName, _colorsData.ExternalRgbHexCode, _colorsData.InternalColorCode, _colorsData.InternalColorName];
    
    NSData *requestData = [NSData dataWithBytes: [requestObject UTF8String] length: [requestObject length]];
    [urlRequest setHTTPBody:requestData];
    
    /*
     {
     Vin: "3FADP4AJ1CM100966",
     StockNumber: "abc123",
     Year: "2012",
     MakeId: "383",
     Make: "Ford",
     ModelId: "29573",
     Model: "Fiesta",
     Trim: "S",
     StyleId: "859263",
     Style: "4dr Sdn S",
     OEMCode: "P4A",
     Options:null,
     ExternalColor: {"Code":"YZ","Name":"Oxford White","Base":null,"RgbHexCode":"FFFFFF"},
     InternalColor: {"Code":"50","Name":"Light Stone","Base":nu
     */
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [urlRequest addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
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
        return YES;
    }
    else{
        [self.caller showErrorMessage: @"Error connecting"];
        return NO;
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
        NSError *error = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
        /*if (isResponseValid) {
            [self.caller returnDataObject:vehicle];
        }
        else{
            [self.caller showErrorMessage: @"Invalid response."];
        }*/
        
    }
    @catch (NSException *exception) {
        [self.caller showErrorMessage: [NSString stringWithFormat:@"Error from the service %@", exception]];
    }
}

@end
