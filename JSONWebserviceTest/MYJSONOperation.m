//
//  MYJSONOperation.m
//  JSONWebserviceTest
//
//  Created by Ben Gordon on 7/24/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYJSONOperation.h"
#import "MYJSONWebservice.h"

@implementation MYJSONOperation

-(void)setUrlPath:(NSString *)path data:(NSData *)data completion:(void (^)(void))block {
    self.urlPath = path;
    self.bodyData = data;
    self.completionBlock = block;
}

-(void)main {
    // Build Request
    NSMutableURLRequest *request = [MYJSONWebservice RequestForMethod:self.urlPath withBodyData:self.bodyData forHttpMethod:HTTP_METHOD_POST];
    // Execute
    NSError *error;
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] init];
    self.responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

@end
