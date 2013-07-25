//
//  MYJSONWebservice.m
//  JSONWebserviceTest
//
//  Copyright (C) 2013, Matt York
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "MYJSONWebservice.h"
#import "MYJSONOperation.h"

#warning Change this base address to the base API address of your server, then delete this line to remove the warning.
#define BASE_API_ADDRESS @"http://192.0.0.1"

@implementation MYJSONWebservice
@synthesize delegate;

-(id)initWithDelegate:(id)newDelegate{
    
    if (self = [super init]) {
        self.delegate = (id <WebserviceDelegate>)newDelegate;
        self.MYJSONOperationQueue = [[NSOperationQueue alloc] init];
        [self.MYJSONOperationQueue setMaxConcurrentOperationCount:kMaxConcurrentConnections];
        return self;
    }
    
    return nil;
}


#pragma mark - Delegated Web Methods
-(void)sampleWebserviceMethod:(NSString *)sampleString{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Build body data
        NSError *error;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:@{@"SampleString": sampleString} options:NSJSONWritingPrettyPrinted error:&error];
        
        // Bad Data
        if (!bodyData) {
            [self sampleWebserviceMethodDidFail];
            return;
        }
        
        // Create Operation & Make Request
        MYJSONOperation *operation = [[MYJSONOperation alloc] init];
        __weak MYJSONOperation *weakOperation = operation;
        [operation setUrlPath:@"/api/Controller/Method" data:bodyData completion:^{
            //Handle response data
            if (weakOperation.responseData) {
                //Optional line to view the raw JSON response packet
                NSLog(@"%@", [[NSString alloc] initWithData:weakOperation.responseData encoding:NSUTF8StringEncoding]);
                
                //Build NSDictionary from response data
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if (responseDictionary) {
                    //Handle successfully converted response dictionary with delegate callback
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate sampleMethodDidReturnWithDictionary:responseDictionary];
                    });
                }
                else {
                    [self sampleWebserviceMethodDidFail];
                }
                
            }
            else {
                [self sampleWebserviceMethodDidFail];
            }
        }];
        [self.MYJSONOperationQueue addOperation:operation];
    });
}

-(void)sampleComplexWebserviceMethod:(MYSampleClass *)sampleClass {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Build body data
        NSError *error;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[MYSampleClass dictionaryForMYSampleClass:sampleClass] options:NSJSONWritingPrettyPrinted error:&error];
        
        // Bad Data
        if (!bodyData) {
            [self sampleWebserviceMethodDidFail];
            return;
        }
        
        //Optional line that prints out the JSON packet to the console
        NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
        
        // Create Operation & Make Request
        MYJSONOperation *operation = [[MYJSONOperation alloc] init];
        __weak MYJSONOperation *weakOperation = operation;
        [operation setUrlPath:@"/api/Controller/ComplexMethod" data:bodyData completion:^{
            //Handle response data
            if (weakOperation.responseData) {
                //Optional line to view the raw JSON response packet
                NSLog(@"%@", [[NSString alloc] initWithData:weakOperation.responseData encoding:NSUTF8StringEncoding]);
                
                //Build NSDictionary from response data
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if (responseDictionary) {
                    //Handle successfully converted response dictionary with delegate callback
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate sampleMethodDidReturnWithDictionary:responseDictionary];
                    });
                }
                else {
                    [self sampleWebserviceMethodDidFail];
                }
                
            }
            else {
                [self sampleWebserviceMethodDidFail];
            }
        }];
        [self.MYJSONOperationQueue addOperation:operation];
    });
}


#pragma mark - Block Based Web Methods
-(void)sampleWebserviceMethod:(NSString *)sampleString completion:(SampleWebserviceBlock)completion {
    //Build body data
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:@{@"SampleString": sampleString} options:NSJSONWritingPrettyPrinted error:&error];
    
    // Bad Data
    if (!bodyData) {
        completion(nil);
        return;
    }
    
    // Create Operation & Make Request
    MYJSONOperation *operation = [[MYJSONOperation alloc] init];
    __weak MYJSONOperation *weakOperation = operation;
    [operation setUrlPath:@"/api/Controller/Method" data:bodyData completion:^{
        if (weakOperation.responseData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion((NSDictionary *)[NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil]);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }];
    [self.MYJSONOperationQueue addOperation:operation];
}

-(void)sampleComplexWebserviceMethod:(MYSampleClass *)sampleClass completion:(SampleComplexWebserviceBlock)completion {
    //Build body data
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[MYSampleClass dictionaryForMYSampleClass:sampleClass] options:NSJSONWritingPrettyPrinted error:&error];
    
    // Bad Data
    if (!bodyData) {
        completion(nil);
        return;
    }
    
    // Create Operation & Make Request
    MYJSONOperation *operation = [[MYJSONOperation alloc] init];
    __weak MYJSONOperation *weakOperation = operation;
    [operation setUrlPath:@"/api/Controller/ComplexMethod" data:bodyData completion:^{
        if (weakOperation.responseData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion((NSDictionary *)[NSJSONSerialization JSONObjectWithData:weakOperation.responseData options:NSJSONReadingMutableContainers error:nil]);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
    }];
    [self.MYJSONOperationQueue addOperation:operation];
}


#pragma Request/Response SupportMethods
-(void)sampleWebserviceMethodDidFail{
    dispatch_async(dispatch_get_main_queue(), ^{
        [delegate sampleMethodDidReturnWithDictionary:nil];
    });
}


#pragma mark - Request Builder
+(NSMutableURLRequest *)RequestForMethod:(NSString *)method withBodyData:(NSData *)data forHttpMethod:(NSString *)httpMethod{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_API_ADDRESS, method]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [request setHTTPBody:data];
    [request setHTTPMethod:httpMethod];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
@end





#pragma mark - MySampleClass Implementation
/*  This is a class created purely for the sake of demoing webservice interaction with a custom object.
    Its use is restricted to viewDidLoad: in MYViewController.m (construction) and the "sampleComplexWebserviceMethod"
    in MYJSONWebservice.m (consumption). You may delete its interface and implementation at your discretion.
 */

@implementation MYSampleClass

+(NSDictionary *)dictionaryForMYSampleClass:(MYSampleClass *)sample{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (sample.FirstName) {
        [dict setValue:sample.FirstName forKey:@"FirstName"];
    }
    if (sample.LastName) {
        [dict setValue:sample.FirstName forKey:@"LastName"];
    }
    
    [dict setValue:[NSNumber numberWithInt:sample.Age] forKey:@"Age"];
    
    return dict;
}

@end
