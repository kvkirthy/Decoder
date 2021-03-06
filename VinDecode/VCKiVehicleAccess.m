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

-(void) postVehicleImage: (NSData *) imageData and: (NSString *)postData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"vehicleImageUri"]];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"-----------------------------7dd38a1060692";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\nContent-Disposition: form-data; name=\"assetType\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat: @"\r\n\r\n%@",postData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\nContent-Disposition: form-data; name=\"images\"; filename=\"iphoneFile.jpg\""dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[@"\r\nContent-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\nContent-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n-------------------------------7dd38a1060692--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        @try {
            
            if (data.length > 0 && !connectionError) {
                if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                    NSString* imagePostResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    @try {
                        NSError *error = nil;
                        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                        NSDictionary *uploadStatus = [(NSArray*)[res objectForKey:@"uploadStatus"] objectAtIndex:0];
                        if(uploadStatus)
                        {
                            id returnedObject = [uploadStatus objectForKey:@"assetId"];
                            [self.caller returnDataObject:returnedObject];
                        }
                    }
                    @catch (NSException *exception) {
                        @throw [NSException exceptionWithName:@"Invalid response" reason:@"unexpected JSON from server" userInfo:nil];
                    }
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
            [self.caller showErrorMessage:exception.description];
        }
    }];
    
}

-(BOOL) createVehicle
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?json=true",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"vehicleDataApi"]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString* imageIds;
    if(_vehBasicData.images && [_vehBasicData.images count] > 0)
    {
        
        for (int i=0; i<[_vehBasicData.images count]; i++) {
            if (i == 0) {
                imageIds = [NSString stringWithFormat:@"\"%@\"",[_vehBasicData.images objectAtIndex:i]];
            }
            else{
                imageIds = [NSString stringWithFormat:@"%@,\"%@\"",imageIds,[_vehBasicData.images objectAtIndex:i]];
            }
            
        }
    }
    else
    {
        imageIds = [NSString stringWithFormat:@"null"];
    }
    
    NSString* optionsJson = [NSString stringWithFormat:@"[]"];
    if(_optionsData && [_optionsData count] > 0)
    {
        for (int i=0; i < [_optionsData count]; i++) {
            VCKiOptionsEntity *optionsEntity = [_optionsData objectAtIndex:i];
            if(i ==0 )
            {
                optionsJson = [NSString stringWithFormat:@"{Description:\"%@\", OptionCode:\"%@\"}", optionsEntity.OptionDescription, optionsEntity.OptionCode];
            }
            else
            {
                optionsJson = [NSString stringWithFormat:@"%@,{Description:\"%@\", OptionCode:\"%@\"}", optionsJson, optionsEntity.OptionDescription, optionsEntity.OptionCode];
                
            }
        }
        optionsJson = [NSString stringWithFormat:@"[%@]",optionsJson];
    }
    
  
    NSString* requestObject = [NSString stringWithFormat:@"{Vin: \"%@\", StockNumber: \"%@\", Year: \"%@\", MakeId: \"%@\", ModelId: \"%@\", Model: \"%@\", Trim: \"%@\", StyleId: \"%@\", Style: \"%@\", OEMCode: \"%@\", Options:%@,photoIds:[%@], ExternalColor: {Code:\"%@\", Name: \"%@\", RgbHexCode: \"%@\"}, InternalColor: {Code:\"%@\", Name: \"%@\"}}", _vehBasicData.vin, _vehBasicData.stockNumber, _vehBasicData.year, _vehBasicData.makeId, _vehBasicData.modelId, _vehBasicData.model, _taxonomyData.Trim, _taxonomyData.StyleId, _taxonomyData.Style, _taxonomyData.OEMModelCode, optionsJson, imageIds, _colorsData.ExternalColorCode, _colorsData.ExternalColorName, _colorsData.ExternalRgbHexCode, _colorsData.InternalColorCode, _colorsData.InternalColorName];

    
    NSData *requestData = [NSData dataWithBytes: [requestObject UTF8String] length: [requestObject length]];
    [urlRequest setHTTPBody:requestData];
    
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
        
        if([(NSString *)[res objectForKey:@"Vin"] isEqualToString:self.vehBasicData.vin])
        {
            [self.caller returnDataObject:@"We have a new vehicle"];
        }
        else
        {
            [self.caller returnDataObject:@"Agh! A failure causing problems. Vehicle not added to inventory"];
        }
        
    }
    @catch (NSException *exception) {
        [self.caller showErrorMessage: [NSString stringWithFormat:@"Error from the service %@", exception]];
    }
}

@end
