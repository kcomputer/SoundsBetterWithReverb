//
//  SBWRDetailsViewController.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBWRDetailsViewController : UIViewController

@property (copy, nonatomic) NSMutableDictionary *data;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithData: (NSMutableDictionary *)data;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
