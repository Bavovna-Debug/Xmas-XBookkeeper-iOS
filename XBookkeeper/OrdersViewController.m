//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "Bookkeeping.h"
#import "Order.h"
#import "OrdersViewController.h"
#import "OrderTableViewCell.h"
#import "OrderViewController.h"

@implementation OrdersViewController
{
    NSIndexPath *lastIndexPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    application.ordersTableView = self.tableView;
/*
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (lastIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:lastIndexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionBottom];
        lastIndexPath = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    lastIndexPath = [self.tableView indexPathForSelectedRow];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showOrder"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
        Order *order = [bookkeeping.orders objectAtIndex:indexPath.row];
        OrderViewController *controller = (OrderViewController *)[[segue destinationViewController] topViewController];
        [controller setOrder:order];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
        return [bookkeeping.orders count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddOrderCell"];

        return cell;
    } else {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];

        Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
        Order *order = [bookkeeping.orders objectAtIndex:indexPath.row];
        [cell setOrder:order];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
        [bookkeeping.orders removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
