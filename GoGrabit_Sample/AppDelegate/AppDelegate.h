//
//  AppDelegate.h
//  GoGrabit_Sample
//
//  Created by macbook on 21/02/18.
//  Copyright © 2018 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//AlertView method
+(void) showAlert:(NSString *)title withMessage:(NSString *) msg;


@end

