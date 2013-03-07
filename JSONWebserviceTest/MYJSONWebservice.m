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

#warning Change this base address to the base API address of your server, then delete this line to remove the warning.
#define BASE_API_ADDRESS @"http://192.0.0.1"

#define HTTP_METHOD_POST @"POST"
#define HTTP_METHOD_GET @"GET"
#define HTTP_METHOD_PUT @"PUT"
#define HTTP_METHOD_DELETE @"DELETE"

@implementation MYJSONWebservice
@synthesize delegate;

-(id)initWithDelegate:(id)newDelegate{
    
    if (self = [super init]) {
        self.delegate = (id <WebserviceDelegate>)newDelegate;
        return self;
    }
    
    return nil;
}

#pragma mark - Web Methods

-(void)sampleWebserviceMethod:(NSString *)sampleString{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //Build body data
        NSError *error;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:@{@"SampleString": sampleString} options:NSJSONWritingPrettyPrinted error:&error];
        
        //Optional line that prints out the JSON packet to the console
        NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
        
        //Error handle if there was a problem creating the body data
        if (!bodyData) {
            NSLog(@"Request creation failed with error code: %d", error.code);
            //Callback with response on the main thread
            [self sampleWebserviceMethodDidFail];
        }
        
        NSMutableURLRequest *request = [MYJSONWebservice RequestForMethod:@"/api/Controller/Method" withBodyData:bodyData forHttpMethod:HTTP_METHOD_POST];
        
        //Make request
        NSURLResponse *response;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        //Handle response data
        if (responseData) {
            //Optional line to view the raw JSON response packet
            NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            
            //Build NSDictionary from response data
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
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
    });
    
}

-(void)sampleComplexWebserviceMethod:(MYSampleClass *)sampleClass {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //Build body data
        NSError *error;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:[MYSampleClass dictionaryForMYSampleClass:sampleClass] options:NSJSONWritingPrettyPrinted error:&error];
        
        //Optional line that prints out the JSON packet to the console
        NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
        
        //Error handle if there was a problem creating the body data
        if (!bodyData) {
            NSLog(@"Request creation failed with error code: %d", error.code);
            //Callback with response on the main thread
            [self sampleWebserviceMethodDidFail];
        }
        
        NSMutableURLRequest *request = [MYJSONWebservice RequestForMethod:@"/api/Controller/ComplexMethod" withBodyData:bodyData forHttpMethod:HTTP_METHOD_POST];
        
        //Make request
        NSURLResponse *response;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //Handle ResponseData
        if (responseData) {
            //Optional line to view the raw JSON response packet
            NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
            
            //Build NSDictionary from response data
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
            if (responseDictionary) {
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
    });
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
/* This is a class created purely for the sake of demoing webservice interaction with a custom object. Its use is restricted to viewDidLoad: in MYViewController.m (construction) and the "sampleComplexWebserviceMethod" in MYJSONWebservice.m (consumption). You may delete its interface and implementation at your discretion.
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
/***************************************************************/
@end
