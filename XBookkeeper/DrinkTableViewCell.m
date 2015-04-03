//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "BookkeeperAppDelegate.h"
#import "DrinkTableViewCell.h"
#import "Order.h"
#import "OrderViewController.h"

@interface DrinkTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel             *drinkName;
@property (weak, nonatomic) IBOutlet UISegmentedControl  *typeOfWine;
@property (weak, nonatomic) IBOutlet UISegmentedControl  *typeOfCup;

@end

@implementation DrinkTableViewCell

@synthesize drink = _drink;

- (void)setDrink:(Drink *)drink
{
    _drink = drink;

    if ([drink isKindOfClass:[MulledWine class]]) {
        [self.drinkName setText:@"Glühwein"];
        [self.typeOfWine setHidden:NO];

        MulledWine *wine = (MulledWine *)self.drink;
        switch ([wine wineType])
        {
            case MulledWinePur:
                [self.typeOfWine setSelectedSegmentIndex:0];
                break;

            case MulledWineWithRum:
                [self.typeOfWine setSelectedSegmentIndex:1];
                break;

            case MulledWineWithAmaretto:
                [self.typeOfWine setSelectedSegmentIndex:2];
                break;

            case MulledWineWithLiqueur:
                [self.typeOfWine setSelectedSegmentIndex:3];
                break;

            default:
                break;
        }
    } else if ([drink isKindOfClass:[Punch class]]) {
        [self.drinkName setText:@"Kinderpunsch"];
        [self.typeOfWine setHidden:YES];
    }

    if ([drink cup] == YES) {
        [self.typeOfCup setSelectedSegmentIndex:0];
    } else {
        [self.typeOfCup setSelectedSegmentIndex:1];
    }
}

- (IBAction)typeOfWineChanged
{
    switch ([self.typeOfWine selectedSegmentIndex])
    {
        case 0:
        {
            MulledWine *wine = (MulledWine *)self.drink;
            [wine setWineType:MulledWinePur];
            break;
        }

        case 1:
        {
            MulledWine *wine = (MulledWine *)self.drink;
            [wine setWineType:MulledWineWithRum];
            break;
        }

        case 2:
        {
            MulledWine *wine = (MulledWine *)self.drink;
            [wine setWineType:MulledWineWithAmaretto];
            break;
        }

        case 3:
        {
            MulledWine *wine = (MulledWine *)self.drink;
            [wine setWineType:MulledWineWithLiqueur];
            break;
        }

        default:
            break;
    }
}

- (IBAction)typeOfCupChanged
{
    switch ([self.typeOfCup selectedSegmentIndex])
    {
        case 0:
            [self.drink setCup:YES];
            break;

        case 1:
            [self.drink setCup:NO];
            break;

        default:
            break;
    }

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

- (IBAction)deleteButtonPressed
{
    UITableView *tableView = (UITableView *)self.superview.superview;
    UITableViewController *tableViewController = (UITableViewController *)tableView.dataSource;
    OrderViewController *controller = (OrderViewController *)tableViewController.parentViewController;
    Order *order = [controller order];

    [order.orderedWine removeObject:self.drink];
    [order.orderedPunch removeObject:self.drink];

    [tableView reloadData];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

@end

@interface DrinkTableViewPawnCupsCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberOfPawnCups;

@end

@implementation DrinkTableViewPawnCupsCell

@synthesize order = _order;

- (void)setOrder:(Order *)order
{
    _order = order;

    if ([order broughtPawnCups] == 0) {
        [self.numberOfPawnCups setText:@"-"];
    } else {
        [self.numberOfPawnCups setText:[NSString stringWithFormat:@"%lu", (unsigned long)[order broughtPawnCups]]];
    }
}

- (IBAction)minusPressed
{
    if ([self.order broughtPawnCups] > 0)
        [self.order setBroughtPawnCups:[self.order broughtPawnCups] - 1];

    [self.numberOfPawnCups setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.order broughtPawnCups]]];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

- (IBAction)plusPressed
{
    [self.order setBroughtPawnCups:[self.order broughtPawnCups] + 1];

    [self.numberOfPawnCups setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.order broughtPawnCups]]];

    BookkeeperAppDelegate *application = [[UIApplication sharedApplication] delegate];
    [application currentOrderChanged];
}

@end