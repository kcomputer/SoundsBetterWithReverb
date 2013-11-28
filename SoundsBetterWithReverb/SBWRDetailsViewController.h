//
//  SBWRDetailsViewController.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBWRDetailsViewController : UIViewController

@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithStringUrl: (NSString *) stringUrl;

@end
