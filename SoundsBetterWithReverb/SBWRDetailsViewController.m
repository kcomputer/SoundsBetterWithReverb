//
//  SBWRDetailsViewController.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRDetailsViewController.h"

@interface SBWRDetailsViewController ()<UIScrollViewDelegate>{
    NSMutableString *description;
    NSURL *imageUrl;
    

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SBWRDetailsViewController

- (id)initWithData: (NSMutableDictionary *)data;
{
    imageUrl = [[NSURL alloc] initWithString:[[data valueForKey:@"content"] valueForKey:@"imageUrl"]];
    description = [data valueForKey:@"description"];
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
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = [self.data valueForKey:@"title"];
    // Do any additional setup after loading the view from its nib.
    [self resetImage];
    [self.webView loadHTMLString:description baseURL:[[NSURL alloc] initWithString:@"http://www.soundsbetterwithreverb.com/blog/"]];
}




- (void)resetImage
{
    if (self.scrollView) {
        self.imageView.image = nil;
        self.spinner.hidesWhenStopped = YES;
        [self.spinner startAnimating];      // if self.spinner is nil, does nothing
        NSURL *imageURL = imageUrl;    // grab the URL before we start (then check it below)
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            [NSThread sleepForTimeInterval:2.0]; // simulate network latency for testing
            // really we should probably keep a count of threads claiming network activity
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // bad
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];  // could take a while
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // bad
            // UIImage is one of the few UIKit objects which is thread-safe, so we can do this here
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            // check to make sure we are even still interested in this image (might have touched away)
            if (imageUrl == imageURL) {
                // dispatch back to main queue to do UIKit work
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
//                        self.scrollView.zoomScale = 1.0;
//                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];  // spinner should have hidesWhenStopped set
                });
            }
        });
    }
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
