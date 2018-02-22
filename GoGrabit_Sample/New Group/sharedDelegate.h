//
//  sharedDelegate.h
//  GoGrabit_Sample
//
//  Created by macbook on 21/02/18.
//  Copyright © 2018 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol  SharedDelegate <NSObject>

@optional
//Server Methods
- (void) successfulResponseFromServer:(NSDictionary *)dict;
- (void) failResponseFromServer;

@end

@interface sharedDelegate : NSObject{
     UIActivityIndicatorView *activity;
    UIView *activityView;
}

//Self delegate
@property (strong, nonatomic) id <SharedDelegate> sharedDelegateid;

//Internet availability
@property (nonatomic) BOOL InternetAvailable;

+ (id) sharedInstance;

//Alertview
+ (void) showAlert:(NSString *)title withMessage:(NSString *) msg withView:(UIViewController *)view;

-(void) startActivity:(UIView *)view;
-(void) stopactivity;


//AFNetworking Webservice call
//Post method
- (void) callWebServiceWith_DomainName:(NSString *)domainStr postData:(NSMutableDictionary *)parameters headerAuth:(NSString *)auth;
@end
