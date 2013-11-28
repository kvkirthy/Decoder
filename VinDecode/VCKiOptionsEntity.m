//
//  VCKiOptionsEntity.m
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiOptionsEntity.h"

@implementation VCKiOptionsEntity

NSMutableData *receivedData;

-(id) initWithObject: (id)callingObject
{
    receivedData = [[NSMutableData alloc]init];
    self.caller = callingObject;
    return self;
}

-(void) GetOptionsEntitiesForStyleId: (NSString *) styleId
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?styleCode=%@&json=true",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"optionsDataApi"],styleId];
    
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
       
        NSError *error = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];

        if (error) {
            [self.caller showErrorMessage: [NSString stringWithFormat:@"%@. Original error - %@",@"Invalid response", error]];
        }
        else{
            [self.caller returnDataObject:res];
        }
        
    }
    @catch (NSException *exception) {
        [self.caller showErrorMessage: [NSString stringWithFormat:@"Error from the service. Original Error - %@", exception]];
    }
}


@end
