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
    
    //Alert view declaration
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

-(void) startActivity:(UIView *)view{
    //AcivityIndicator allocation
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //activity view allocation for unaccessing
    activityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    //adding to current view
    [view addSubview:activityView];
    activityView.hidden = false;
    activity.center=activityView.center;
    //adding activityindicator to created view
    [activityView addSubview:activity];
    //Start activity indicator
    [activity startAnimating];
}

-(void) stopactivity{
    [activity stopAnimating];
    activityView.hidden = true;
    [activityView removeFromSuperview];
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
    
    //Adding parameter to Requests
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
//        NSLog(@"Json---->%@",json);
    }else{
        NSLog(@"log");
        [AppDelegate showAlert:@"Internet Error" withMessage:@"Please check your network connection"];
    }
    if ([response statusCode] >= 400){
        
        if (json !=nil) {
            //response from server
            [sharedDelegateid successfulResponseFromServer:json];
        }else{
            //No response from server
            [sharedDelegateid failResponseFromServer];
        }
    }else{
        if ([sharedDelegate respondsToSelector:@selector(successfulResponseFromServer:)]){
            //success method
            [sharedDelegateid successfulResponseFromServer:json];
            NSLog(@"success");
        }else if ([sharedDelegate respondsToSelector:@selector(failResponseFromServer)]){
            //Failure method
            [sharedDelegateid failResponseFromServer];
            NSLog(@"error");
        }
    }
    json = nil;
    domainStr = nil;
    parameters = nil;
}

@end
