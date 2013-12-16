//
//  SBWRContentXMLParser.m
//  SoundsBetterWithReverb
//
//  Created by Emil on 12/9/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import "SBWRContentXMLParser.h"
@interface SBWRContentXMLParser ()
{
    NSXMLParser *parser;
    NSData *contentForParserToInint;
    NSMutableDictionary *content;
    
    NSMutableString *imageUrl;
    NSMutableString *description;
    NSMutableString *audio;
    NSMutableString *video;
    
    NSString *element;
    
}
@end

@implementation SBWRContentXMLParser


- (NSString *) fixHtmlString:(NSString *) stringToFix{
    NSString *correctHtmlString;
    
    if ([stringToFix rangeOfString:@"&nbsp;<br />\n<strong>"].location != NSNotFound)
    {
        correctHtmlString = [stringToFix stringByReplacingOccurrencesOfString:@"&nbsp;<br />\n<strong>" withString:@"<strong>"];
        correctHtmlString = [correctHtmlString stringByReplacingOccurrencesOfString:@"</audio>" withString:@"</audio></p>"];
        correctHtmlString= [correctHtmlString stringByAppendingString:@"</content>"];
    }
    else {
          correctHtmlString= [stringToFix stringByAppendingString:@"</p></content>"];
    }

    correctHtmlString = [@"<content>" stringByAppendingString:correctHtmlString];
    
    correctHtmlString =
    [correctHtmlString stringByReplacingOccurrencesOfString:@"<p>&" withString:@"<p><![CDATA[&"];
    correctHtmlString =
    [correctHtmlString stringByReplacingOccurrencesOfString:@";</p>" withString:@";]]></p>"];
    
    correctHtmlString =
    [correctHtmlString stringByReplacingOccurrencesOfString:@"<h2>" withString:@"<h2><![CDATA["];
    correctHtmlString =
    [correctHtmlString stringByReplacingOccurrencesOfString:@"</h2>" withString:@"]]></h2>"];
    correctHtmlString =
    [correctHtmlString stringByReplacingOccurrencesOfString:@")</p" withString:@"]]>)</p"];
    return correctHtmlString;
    
}

- (NSMutableDictionary *) getContent: (NSString *)htmlStringWithContent {
    NSString *correctHtmlString = [self fixHtmlString :htmlStringWithContent];
    contentForParserToInint = [correctHtmlString dataUsingEncoding:NSUTF8StringEncoding];
    if(contentForParserToInint)
    {
        content = [[NSMutableDictionary alloc] init];
        
        parser = [[NSXMLParser alloc] initWithData:contentForParserToInint];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    }
    return content;
}


#pragma mark - XMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"img"]) {        
        imageUrl = [[NSMutableString alloc] init];
        imageUrl = [attributeDict valueForKey:@"src"];
        return;
    }
    if ([element isEqualToString:@"h2"]) {
        description = [[NSMutableString alloc] init];
        return;
    }
    if ([element isEqualToString:@"audio"]) {
        audio = [[NSMutableString alloc] init];
        audio = [attributeDict valueForKey:@"src"];
        return;
    }
    if ([element isEqualToString:@"iframe"]) {

        video = [[NSMutableString alloc] init];
        video = [attributeDict valueForKey:@"src"];
        return;
    }
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError userInfo]);
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"h2"]  ){
        [description appendString:string];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {

    [content setObject:imageUrl forKey:@"imageUrl"];
    [content setObject:description forKey:@"description"];
    [content setObject:audio forKey:@"audio"];
}

@end
