//
//  SBWRDetailsViewController.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/29/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRDetailsViewController.h"

@interface SBWRDetailsViewController (){
    NSMutableString *description;
    NSURL *imageUrl;
    NSURL *audioURL;
    NSString *link;
    NSMutableString *title;
    UIImage *imageForDetailView;
    

}
@property (nonatomic, strong) AVPlayer* player;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SBWRDetailsViewController

- (id)initWithData: (NSMutableDictionary *)data andImage:(UIImage *)imageData
{
    imageUrl = [[NSURL alloc] initWithString:[[data valueForKey:@"content"] valueForKey:@"imageUrl"]];
    description = [[data valueForKey:@"content"] valueForKey:@"description"];
    title = [data valueForKey:@"title"];
    audioURL = [[NSURL alloc] initWithString:[[data valueForKey:@"content"] valueForKey:@"audio"]];
    link = [data valueForKey:@"link"];
    
    imageForDetailView = imageData;
    
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
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setContentSize:CGSizeMake(320, 625)];
    self.scrollView.delegate = self;
    [self resetImage];

    self.TitleForPost.text = title;
    [self.webView loadHTMLString:description baseURL:[[NSURL alloc] initWithString:@"http://www.soundsbetterwithreverb.com/blog/"]];
    
    AVPlayerItem *anItem = [AVPlayerItem playerItemWithURL:audioURL];
    
    
    _player = [AVPlayer playerWithPlayerItem:anItem];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)resetImage
{
    if (imageForDetailView == [NSNull null]){
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
                            //self.scrollView.contentSize = image.size;
                            self.imageView.image = image;
                            self.imageView.frame = CGRectMake(0, 64, 320, 320);
                        }
                        [self.spinner stopAnimating];  // spinner should have hidesWhenStopped set
                    });
                }
            });
        }
    }
    else{
        if (self.scrollView) {
        self.imageView.image = imageForDetailView;
        self.imageView.frame = CGRectMake(0, 64, 320, 320);
        }
    }
}


- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

//- (UITextField *) titleField{
//    if (!_titleField) _titleField = [[UITextField alloc] initWithFrame:CGRectZero];
//    return _titleField;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SBWRButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)play:(UIButton *) senderButton{
    [_player play];
    _playButton.hidden = YES;
    _pauseButton.hidden = NO;
}

- (IBAction)pause:(UIButton *)sender{
    [_player pause];
    _pauseButton.hidden = YES;
    _playButton.hidden = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.viewToScroll;
}

- (IBAction)postToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        NSString *stringForTweetSheet = [title stringByAppendingString:@": "];
        stringForTweetSheet = [stringForTweetSheet stringByAppendingString:link];

        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:stringForTweetSheet];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}


@end
