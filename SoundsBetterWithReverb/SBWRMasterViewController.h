//
//  SBWRMasterViewController.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/28/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWRDetailsViewController.h"

@interface SBWRMasterViewController : UIViewController <NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
