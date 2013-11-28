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
    NSString *element;
}
@end

@implementation SBWRMasterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.soundsbetterwithreverb.com/feed/"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
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




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"] && ![string isEqualToString:@"\n\t\t"] ){
        [title appendString:string];
        ///NSLog(@"Title is: %@", string);
    } else if ([element isEqualToString:@"content:encoded"] && ![string isEqualToString:@"n\t\t\t"] && ![string isEqualToString:@"n\t\t\t\t"]) {
        [link appendString:string];
        //NSLog(@"Link is: %@", string);
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
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
