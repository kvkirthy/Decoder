//
//  VCKiDataAccessProtocol.h
//  VinDecode
//
//  Created by foeteam on 11/27/13.
//  Copyright (c) 2013 VenCKi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCKiDataAccessProtocol <NSObject>

// This message used for successfull data returned from network operation.
-(void)returnDataObject:(id)returnData;

// This message used for notifying user on error.
-(void) showErrorMessage: (NSString *) errorMessage;

@end
