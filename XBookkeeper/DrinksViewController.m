//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "Drink.h"
#import "DrinksViewController.h"
#import "DrinkTableViewCell.h"
#import "OrderViewController.h"

@implementation DrinksViewController

- (IBAction)orderWinePressed
{
    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    MulledWine *drink = [[MulledWine alloc] init];
    [order.orderedWine addObject:drink];
    
    [self.tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

- (IBAction)orderPunchPressed
{
    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    Punch *drink = [[Punch alloc] init];
    [order.orderedPunch addObject:drink];

    [self.tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

- (IBAction)minusPawnPressed
{
    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    if ([order broughtPawnCups] == 0)
        [order setBroughtPawnCups:1];

    [self.tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    return (order == nil) ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;

        case 1:
        {
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            return [order.orderedWine count];
        }

        case 2:
        {
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            return [order.orderedPunch count];
        }

        case 3:
        {
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            return ([order broughtPawnCups] == 0) ? 0 : 1;
        }

        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrinkOrderingCell"];
            return cell;
        }

        case 1:
        {
            DrinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrinkDetailsCell"];
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            Drink *drink = [order.orderedWine objectAtIndex:indexPath.row];
            [cell setDrink:drink];
            return cell;
        }

        case 2:
        {
            DrinkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DrinkDetailsCell"];
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            Drink *drink = [order.orderedPunch objectAtIndex:indexPath.row];
            [cell setDrink:drink];
            return cell;
        }

        case 3:
        {
            DrinkTableViewPawnCupsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PawnCupsCell"];
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            [cell setOrder:order];
            return cell;
        }

        default:
            return nil;
    }
}

@end
