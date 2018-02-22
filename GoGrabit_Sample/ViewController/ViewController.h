//
//  ViewController.h
//  GoGrabit_Sample
//
//  Created by macbook on 21/02/18.
//  Copyright © 2018 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    //Declaring TextField
    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    //Declaring Button
    IBOutlet UIButton *signIn;
    //Declaring activityindicator
//    UIActivityIndicatorView *activity;
}

//Button click methods
- (IBAction)hiddenText:(id)sender;
- (IBAction)hiddenTextFalse:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;


@end

