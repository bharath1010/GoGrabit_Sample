//
//  ViewController.m
//  GoGrabit_Sample
//
//  Created by macbook on 21/02/18.
//  Copyright © 2018 macbook. All rights reserved.
//

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Signin Button corner radius 
    signIn.layer.cornerRadius = 10;
    signIn.layer.masksToBounds = YES;
    
    //Crashlytics check With button
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(20, 50, 100, 30);
//    [button setTitle:@"Crash" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(crashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

    // Do any additional setup after loading the view, typically from a nib.
}

//Crashlytics check With button Action

//- (IBAction)crashButtonTapped:(id)sender {
//    [[Crashlytics sharedInstance] crash];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Shared delegate intialize
    ObjShared = nil;
    ObjShared = [sharedDelegate sharedInstance];
    ObjShared.sharedDelegateid = nil;
    ObjShared.sharedDelegateid = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Passord Visbile Text is false Event-Touchupinside
- (IBAction)hiddenText:(id)sender {
    password.secureTextEntry = true;
}
//Passord Visbile Text is false Event-Touchdown
- (IBAction)hiddenTextFalse:(id)sender{
    password.secureTextEntry = false;
}

//Forgot password clicked
- (IBAction)forgotPassword:(id)sender {
    [sharedDelegate showAlert:@"Forgot Paasord" withMessage:@"Clicked on the Forgot password" withView:self];
}

//Sign In Clicked
- (IBAction)signIn:(id)sender {
    if (![self isValidEmail:username.text]){
        //Vailding Email Id
        [sharedDelegate showAlert:@"Error" withMessage:@"Email-Id is Invaild" withView:self];
    }else if (password.text.length == 0){
        //Vailding Password
        [sharedDelegate showAlert:@"Error" withMessage:@"Password is invaild" withView:self];
    }else if([username.text isEqualToString:@"grabit@test.com"] && [password.text isEqualToString:@"12345678"]){
        //Sample login for testing
        [sharedDelegate showAlert:@"Success" withMessage:@"You have successfully login" withView:self];
    }else{
        //Vaildation passed
        //Login API CAll Method
        
        //To start activity indicator
        [ObjShared startActivity:self.view];
        
        [self LoginAPICall];
    }
}

#pragma APICALL

-(void)LoginAPICall{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Parameters
        NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
        [para setValue: username.text forKey: @"username"];
        [para setValue: password.text forKey: @"password"];
        //Basic Authentation
        NSString *authStr = @"dit:Watermelon!";
        NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
        //Login API call With parameter and authenation values
        [ObjShared callWebServiceWith_DomainName:@"account/login/" postData:para headerAuth:authValue];
    });
}

//Signup Clicked
- (IBAction)signUp:(id)sender {
    [sharedDelegate showAlert:@"SignUp" withMessage:@"Clicked on the Sign Up" withView:self];
}

#pragma Email validation
-(BOOL)isValidEmail:(NSString *)emails{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:emails];
}

#pragma mark -W.S Delegate Call
- (void) successfulResponseFromServer:(NSDictionary *)dict{
    //To Stop activity indicator
    [ObjShared stopactivity];

    //Response from sever
    if ([[NSString stringWithFormat:@"%@",[dict valueForKey:@"status"]] isEqualToString:@"1"]){
        //Success response
        [sharedDelegate showAlert:@"Successfully" withMessage:[dict valueForKey:@"message"] withView:self];
    }else{
        //failure responses
        [sharedDelegate showAlert:@"Error" withMessage:[dict valueForKey:@"message"] withView:self];
    }
}
- (void)failResponseFromServer{
    //To Stop activity indicator
    [ObjShared stopactivity];
    
    //falilure response from sever
    [AppDelegate showAlert:@"Error" withMessage:@"Please Check the Internet"];
}

//Return value of textfield

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //Navigating between textfield and resigning
    if (textField == username) {
        [textField resignFirstResponder];
        [password becomeFirstResponder];
    }
    else if (textField == password) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)dealloc{
    //dealloc the objects
    ObjShared = nil;
    ObjShared.sharedDelegateid = nil;
}

@end
