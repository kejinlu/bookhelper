//
//  bookhelperAppDelegate.h
//  bookhelper
//
//  Created by Luke on 6/22/11.
//  Copyright 2011 Geeklu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookhelperAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
