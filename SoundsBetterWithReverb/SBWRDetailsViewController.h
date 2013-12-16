//
//  SBWRDetailsViewController.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>


@interface SBWRDetailsViewController : UIViewController<UIScrollViewDelegate>

@property (copy, nonatomic) NSMutableDictionary *data;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithData: (NSMutableDictionary *)data andImage:(UIImage *)imageData;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewToScroll;

@property (weak, nonatomic) IBOutlet UILabel *TitleForPost;

@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;


- (IBAction)SBWRButton:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pause:(UIButton *)sender;


- (IBAction)postToTwitter:(id)sender;

@end
