//
//  MYJSONOperation.h
//  JSONWebserviceTest
//
//  Created by Ben Gordon on 7/24/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYJSONOperation : NSOperation

@property (nonatomic, retain) NSString *urlPath;
@property (nonatomic, retain) NSData *bodyData;
@property (nonatomic, retain) NSData *responseData;

// Init
-(void)setUrlPath:(NSString *)path data:(NSData *)data completion:(void (^)(void))block;

@end
