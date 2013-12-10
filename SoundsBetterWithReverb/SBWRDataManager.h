//
//  SBWRDataManager.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 12/9/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBWRContentXMLParser.h"

@interface SBWRDataManager : NSObject <NSXMLParserDelegate>

- (NSMutableArray *) getFeed;

@end
