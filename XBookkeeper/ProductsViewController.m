//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "OrderViewController.h"
#import "Product.h"
#import "ProductsViewController.h"
#import "ProductTableViewCell.h"

@implementation ProductsViewController

- (IBAction)orderProductPressed:(UIButton *)sender
{
    NSDecimalNumber *productPrice = [NSDecimalNumber decimalNumberWithString:[sender.titleLabel text]];
    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    Product *product = [[Product alloc] initWithPrice:productPrice];
    [order.orderedProducts addObject:product];

    [self.tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
            return [order.orderedProducts count];
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductOrderingCell"];
            return cell;
        }

        case 1:
        {
            ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailsCell"];
            OrderViewController *controller = (OrderViewController *)self.parentViewController;
            Order *order = [controller order];
            Product *product = [order.orderedProducts objectAtIndex:indexPath.row];
            [cell setProduct:product];
            return cell;
        }

        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? 112.0f : 64.0f;
}

@end
