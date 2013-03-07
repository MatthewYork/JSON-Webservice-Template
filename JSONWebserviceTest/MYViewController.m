//
//  MYViewController.m
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

#import "MYViewController.h"


@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Instantiate the webservice class and set the delegate to the calling view controller
    MYJSONWebservice *service = [[MYJSONWebservice alloc] initWithDelegate:self];
    
    //Make a simple request
    [service sampleWebserviceMethod:@"SampleString"];
    
    //Request using a complex object
    MYSampleClass *sample = [[MYSampleClass alloc] init];
    sample.FirstName = @"Sample";
    sample.LastName = @"Person";
    sample.Age = 24;
    [service sampleComplexWebserviceMethod:sample];
}


//Handle Sample Response Data
-(void)sampleMethodDidReturnWithDictionary:(NSDictionary *)responseDictionary{
    if (responseDictionary) {
        NSLog(@"%@", responseDictionary);
    }
    else {
        //Handle Error
        NSLog(@"Error making request");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
