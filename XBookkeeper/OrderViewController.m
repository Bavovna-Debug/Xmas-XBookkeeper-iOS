//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "OrderViewController.h"

@implementation OrderViewController

@synthesize order = _order;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tabBar setHidden:(self.order == nil)];
}

- (void)setOrder:(Order *)order
{
    _order = order;

    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;

    if (order != nil) {
        if (self.tabBar.hidden == YES)
            [self.tabBar setHidden:NO];

        [self.navigationItem setTitle:[NSString stringWithFormat:@"Bestellung № %lu", (unsigned long)[order orderNumber]]];
    }
}

@end
