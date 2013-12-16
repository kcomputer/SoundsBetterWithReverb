//
//  SBWRAppDelegate.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/28/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBWRMasterViewController;


@interface SBWRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SBWRMasterViewController *viewController;

@property (strong, nonatomic) UINavigationController *appNavigationController;

@end
