JSON-Webservice-Template
========================

This is a template for JSON webservice interaction. It is designed to be used for rapid-prototyping integration with JSON webservices when starting a new project, especially (but not limited to) those that utilize the MVC4 Web API.


Requirements
========================

This project requires ARC.


Installation
========================

- Add `MYJSONWebservice.h` and `MYJSONWebservice.m` to your project.
- `#import "MYJSONWebservice.h"` to use it in a class
- Subscribe to the 'WebserviceDelegate' to enable delegate/callback interaction.


How To Use It?
========================

To make a request, instantiate a new MYJSONWebservice instance and call the desired webmethod

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
    
To Respond to this request, add the appropriate delegate method to the calling class. An example of this using the provided methods is as so.

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

