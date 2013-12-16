//
//  SBWRMasterViewController.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/28/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRMasterViewController.h"


@interface SBWRMasterViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imageUrl;
    NSMutableString *text;
    NSMutableString *content;
    NSString *element;
    
    NSMutableArray *images;
}
@end

@implementation SBWRMasterViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    dispatch_queue_t loaderQ = dispatch_queue_create("Data downloader", NULL);
    dispatch_async(loaderQ, ^{
        SBWRDataManager *manager= [[SBWRDataManager alloc] init];
        feeds = [manager getFeed];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (feeds){
                [self.tableView reloadData];
            }
        });
    });
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 321;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"CustomCellForSBWR";
    SBWRCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBWRCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    
    if(!images){
        images = [[NSMutableArray alloc] initWithCapacity:feeds.count];
        
        for (int i = 0 ; i != feeds.count ; [images addObject:[NSNull null]], i++);
    }
    
    
    if ([NSNull null] == [images objectAtIndex:indexPath.row]){
        
        NSURL *imageURL = [[NSURL alloc] initWithString:[[[feeds objectAtIndex:indexPath.row] valueForKey:@"content"] valueForKey:@"imageUrl"]];    // grab the URL before we start (then check it below)
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // bad
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageURL];  // could take a while
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // bad
            // UIImage is one of the few UIKit objects which is thread-safe, so we can do this here
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            // check to make sure we are even still interested in this image (might have touched away)
            // dispatch back to main queue to do UIKit work
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    //                        self.scrollView.zoomScale = 1.0;
                    //                        self.scrollView.contentSize = image.size;
                    [images replaceObjectAtIndex:indexPath.row withObject:image];
                    cell.backgroundImage.image = images[indexPath.row];
                    //self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
            });
        });

    }
    else{
        cell.backgroundImage.image =images[indexPath.row];
    }
    
        cell.titleForPost.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];

    
    return cell;

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SBWRDetailsViewController *detailsViewController = [[SBWRDetailsViewController alloc] initWithData:feeds[indexPath.row] andImage:images[indexPath.row]];
    [self.navigationController pushViewController:detailsViewController
                                         animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end
