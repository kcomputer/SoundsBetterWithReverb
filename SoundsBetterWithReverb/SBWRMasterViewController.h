//
//  SBWRMasterViewController.h
//  SoundsBetterWithReverb
//
//  Created by Emil on 11/28/13.
//  Copyright (c) 2013 Emil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWRDetailsViewController.h"
#import "SBWRDataManager.h"

#import "SBWRCustomCell.h"

@interface SBWRMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;




@end
