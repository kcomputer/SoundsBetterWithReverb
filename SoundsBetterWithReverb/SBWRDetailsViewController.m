//
//  SBWRDetailsViewController.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRDetailsViewController.h"

@interface SBWRDetailsViewController ()

@end

@implementation SBWRDetailsViewController


- (id)initWithStringUrl: (NSString *) stringUrl
{
    self.url = [[NSString alloc] initWithString:stringUrl];
    return [self initWithNibName:@"SBWRDetailsViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadHTMLString:_url baseURL:[[NSURL alloc] initWithString:@"http://www.soundsbetterwithreverb.com/blog/"]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
