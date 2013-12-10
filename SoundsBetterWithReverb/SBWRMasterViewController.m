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
                NSLog(@"%@",feeds);
                [self.tableView reloadData];
            }
        });
    });
//    SBWRDataManager *manager= [[SBWRDataManager alloc] init];
//    feeds = [ manager getFeed];
    //[[NSMutableArray alloc] init];
//    NSURL *url = [NSURL URLWithString:@"http://www.soundsbetterwithreverb.com/feed/"];
//    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    [parser setDelegate:self];
//    [parser setShouldResolveExternalEntities:NO];
//    [parser parse];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
//    SBWRContentXMLParser *pars = [[SBWRContentXMLParser alloc] initWithString:[feeds[0] objectForKey:@"link"]];
//    NSLog(@"%@",feeds);

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];

    

    
    return cell;

}








#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
    NSLog(@"Link is: %@", feeds);
    
    
    SBWRDetailsViewController *detailsViewController = [[SBWRDetailsViewController alloc] initWithStringUrl:string];
    [self.navigationController pushViewController:detailsViewController
                                         animated: YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end
