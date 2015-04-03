//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Bookkeeping.h"
#import "Drink.h"
#import "OrderTableViewCell.h"
#import "Product.h"

@implementation AddOrderTableViewCell

- (IBAction)buttonPressed
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];
    [bookkeeping addNewOrder];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:1];

    UITableView *tableView = (UITableView *)self.superview.superview;
    [tableView reloadData];
    /*[tableView insertRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];*/
    [tableView selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionBottom];

    UITableViewController *tableViewController = (UITableViewController *)tableView.dataSource;
    [tableViewController performSegueWithIdentifier:@"showOrder"
                                             sender:self];
}

@end

@interface OrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *marketName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDrinks;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCups;
@property (weak, nonatomic) IBOutlet UILabel *numberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@end

@implementation OrderTableViewCell

@synthesize order = _order;

- (void)setOrder:(Order *)order
{
    _order = order;

    [self refreshValues];
}

- (void)refreshValues
{
    NSString         *timestamp;
    NSUInteger       numberOfDrinks = 0;
    NSInteger        numberOfCups = 0;
    NSUInteger       numberOfProducts = 0;
    NSDecimalNumber  *totalPrice = [NSDecimalNumber zero];

    timestamp = [NSDateFormatter localizedStringFromDate:[self.order timestamp]
                                               dateStyle:NSDateFormatterMediumStyle
                                               timeStyle:NSDateFormatterMediumStyle];

    numberOfDrinks += [self.order.orderedWine count];
    numberOfDrinks += [self.order.orderedPunch count];

    for (Drink *drink in [self.order orderedWine])
        if ([drink cup] == YES)
            numberOfCups++;

    for (Drink *drink in [self.order orderedPunch])
        if ([drink cup] == YES)
            numberOfCups++;

    numberOfCups -= [self.order broughtPawnCups];

    numberOfProducts = [self.order.orderedProducts count];

    totalPrice = [self.order totalPrice];

    [self.orderNumber setText:[NSString stringWithFormat:@"№ %lu", (unsigned long)[self.order orderNumber]]];
    [self.timestamp setText:timestamp];

    [self.marketName setText:[self.order marketName]];

    [self.numberOfDrinks setText:[NSString stringWithFormat:@"%lu", (unsigned long)numberOfDrinks]];

    [self.numberOfCups setText:[NSString stringWithFormat:@"%ld", (long)numberOfCups]];

    [self.numberOfProducts setText:[NSString stringWithFormat:@"%lu", (unsigned long)numberOfProducts]];

    [self.totalPrice setText:[NSString stringWithFormat:@"%0.2f €", [totalPrice floatValue]]];
}

@end
