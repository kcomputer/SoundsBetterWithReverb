//
//  SBWRContentXMLParser.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 12/9/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBWRContentXMLParser : NSObject <NSXMLParserDelegate>

- (NSMutableDictionary *) getContent: (NSString *)htmlStringWithContent;

@end
