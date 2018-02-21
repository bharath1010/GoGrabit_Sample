//
//  sharedDelegate.m
//  GoGrabit_Sample
//
//  Created by macbook on 21/02/18.
//  Copyright © 2018 macbook. All rights reserved.
//

#import "sharedDelegate.h"

@implementation sharedDelegate
@synthesize sharedDelegateid;

#pragma mark - Init Method

+ (id)sharedInstance{
    
    //Below Static variable will hold the instance of this Class(i.e Shared Class)
    static sharedDelegate *sharedC = nil;
    // Below static variable will ensure that initalization code executes only once
    static dispatch_once_t onetoken;
    
    /* Below block will initalize instance of Login Class. And this will be executed only once.
     * Next time coming back to this class won't execute the block
     */
    dispatch_once(&onetoken,^{
        sharedC = [[sharedDelegate alloc] init];
    });
    return sharedC;
}

//AlertView Controller Method
+ (void) showAlert:(NSString *)title withMessage:(NSString *)msg withView:(UIViewController *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    
    [alert addAction:okButton];
    
    [view presentViewController:alert animated:YES completion:nil];
                                
}


#pragma mark - W.S call

//POST WEBSERVICE WITH HEADER and Authorization
- (void) callWebServiceWith_DomainName:(NSString *)domainStr postData:(NSMutableDictionary *)parameters headerAuth:(NSString *)auth{
    NSDictionary* json;
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERPATH,domainStr]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [req addValue:auth forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:jsondata];
    NSData *res = [NSURLConnection  sendSynchronousRequest:req returningResponse:&response error:&error];
    if (res != nil) {
        NSError* sserror = nil;
        json = [NSJSONSerialization JSONObjectWithData:res
                                               options:kNilOptions
                                                 error:&sserror];
    }else{
        NSLog(@"log");
        [AppDelegate showAlert:@"Internet Error" withMessage:@"Please check your network connection"];
    }
    if ([response statusCode] >= 400){
        [AppDelegate showAlert:@"Error" withMessage:@"Please check for Vaild credentials"];
    }else{
        if ([sharedDelegate respondsToSelector:@selector(successfulResponseFromServer:)]){
            [sharedDelegateid successfulResponseFromServer:json];
            NSLog(@"success");
        }else if ([sharedDelegate respondsToSelector:@selector(failResponseFromServer)]){
            [sharedDelegateid failResponseFromServer];
            NSLog(@"error");
        }
    }
    json = nil;
    domainStr = nil;
    parameters = nil;
}

@end
