//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "Bookkeeping.h"
#import "OrderTableViewCell.h"

/*
@interface BookkeeperAppDelegate () <UISplitViewControllerDelegate>

@end
*/

@implementation BookkeeperAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setIdleTimerDisabled:YES];

    [application setStatusBarHidden:YES];

    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    //splitViewController.delegate = self;

    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
    [bookkeeping loadPrices];
    [bookkeeping loadOrders];

    return YES;
}

- (void)currentOrderChanged
{
    if (self.ordersTableView != nil) {
        NSIndexPath *selectedIndexPath = [self.ordersTableView indexPathForSelectedRow];
        OrderTableViewCell *selectedCell = (OrderTableViewCell *)[self.ordersTableView cellForRowAtIndexPath:selectedIndexPath];
        [selectedCell refreshValues];
    }
}

/*
#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}
*/

@end

@implementation RoundCornerButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self.layer setCornerRadius:10.0f];
}

@end
