//
//  SBWRDataManager.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 12/9/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRDataManager.h"

@interface SBWRDataManager ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    
    NSMutableString *htmlStringWithContent;
    NSMutableString *content;
    NSString *element;
    
    SBWRContentXMLParser *contentParser;
}

@end
@implementation SBWRDataManager

- (NSMutableArray *) getFeed{
    
    feeds = [[NSMutableArray alloc] init];
    
    contentParser = [[SBWRContentXMLParser alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://feeds.feedburner.com/soundsbetterwithreverb?fmt=xml"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    return feeds;
}

#pragma mark - XMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        htmlStringWithContent = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:[contentParser getContent: htmlStringWithContent] forKey:@"content"];
        [feeds addObject:[item copy]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"] && ![string isEqualToString:@"\n\t"] && ![string isEqualToString:@"\n\t\t"]){
        [title appendString:string];
        return;
    }
    if ([element isEqualToString:@"link"] && ![string isEqualToString:@"\n\t\t"] && ![string isEqualToString:@"\n\t\t\t\t"] && ![string isEqualToString:@"\n"]) {
        [link appendString:string];
        return;
    }
    if ([element isEqualToString:@"content:encoded"] && ![string isEqualToString:@"\n\t\t\t"] && ![string isEqualToString:@"\n\t\t\t\t"] && ![string isEqualToString:@"\n"]) {
        [htmlStringWithContent appendString:string];
        return;
    }
    
}

@end
