//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "Order.h"
#import "OrderViewController.h"
#import "ProductTableViewCell.h"

@interface ProductTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@end

@implementation ProductTableViewCell

@synthesize product = _product;

- (void)setProduct:(Product *)product
{
    _product = product;

    [self.productPrice setText:[NSString stringWithFormat:@"%0.2f €", [product.price floatValue]]];
}

- (IBAction)deleteButtonPressed
{
    UITableView *tableView = (UITableView *)self.superview.superview;
    UITableViewController *tableViewController = (UITableViewController *)tableView.dataSource;
    OrderViewController *controller = (OrderViewController *)tableViewController.parentViewController;
    Order *order = [controller order];

    [order.orderedProducts removeObject:self.product];

    [tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

@end
