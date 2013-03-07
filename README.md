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


Modifying and Extending
========================

MYJSONWebservice is meant to be a jumping-off point for the creation of your own, self-contained webservice interaction class. It is not meant to be a "drop-in" solution, so much as a guide and model for convenient and portable code.

When creating your own method, add its declaration to the interface found in 'MYJSONWebservice.h' and implement it in 'MYJSONWebservice.m'. Add any new delegate callbacks to the delegate protocol definition. See below for an example

    @protocol WebserviceDelegate
    @optional
    -(void)sampleMethodDidReturnWithDictionary:(NSDictionary *)responseDictionary;
    ...
    -(void)yourNewResponseMethod:(BOOL)response;
    @end


