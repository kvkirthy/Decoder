//
//  VCKi.m
//  VinDecode
//
//  Created by VenCKi on 11/23/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import "VCKiTaxonomyEntity.h"

@implementation VCKiTaxonomyEntity

NSMutableData *receivedData;

-(id) initWithObject: (id)callingObject
{
    receivedData = [[NSMutableData alloc]init];
    self.caller = callingObject;
    return self;
}

-(void)getTaxonomyEntitiesWithYear:(NSString *)year Make:(NSString *)make andModel:(NSString *)model
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?year=%@&make=%@&model=%@&json=true",[[NSUserDefaults standardUserDefaults] stringForKey:@"baseApiUrl"],[[NSUserDefaults standardUserDefaults] stringForKey:@"taxonomyDataApi"],year,make, model];
    
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
        NSMutableArray *taxonomyData = [[NSMutableArray alloc]init];
        NSArray *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&error];
        
        
        if (error) {
            [self.caller showErrorMessage: [NSString stringWithFormat:@"%@. Original error - %@",@"Invalid response", error]];
        }
        else{
            
            for(int i=0; i< [res count]; i++)
            {
                NSDictionary *vehicleAsDictionary = [res objectAtIndex:i];
                
                VCKiTaxonomyEntity *taxonomyObject = [[VCKiTaxonomyEntity alloc]init];
                taxonomyObject.Style = [vehicleAsDictionary objectForKey:@"Style"];
                taxonomyObject.StyleId = [vehicleAsDictionary objectForKey:@"StyleId"];
                taxonomyObject.Trim = [vehicleAsDictionary objectForKey:@"Trim"];
                taxonomyObject.OEMModelCode = [vehicleAsDictionary objectForKey:@"OEMCode"];
                
                [taxonomyData addObject:taxonomyObject];
            }

            [self.caller returnDataObject:taxonomyData];
        }
        
    }
    @catch (NSException *exception) {
        [self.caller showErrorMessage: [NSString stringWithFormat:@"Error from the service. Original Error - %@", exception]];
    }
}


@end
