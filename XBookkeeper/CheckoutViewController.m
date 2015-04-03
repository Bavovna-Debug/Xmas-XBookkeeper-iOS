//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Order.h"
#import "OrderViewController.h"

@interface CheckoutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *paidAmount;
@property (weak, nonatomic) IBOutlet UILabel *changeAmount;
@property (weak, nonatomic) IBOutlet UILabel *calculationError;

@property (strong, nonatomic) NSDecimalNumber *typingValue;
@property (assign, nonatomic) Boolean         typingAfterComma;

@end

@implementation CheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.typingValue = [NSDecimalNumber zero];
    self.typingAfterComma = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.changeAmount setHidden:NO];
    [self.calculationError setHidden:YES];

    OrderViewController *controller = (OrderViewController *)self.parentViewController;
    Order *order = [controller order];
    NSDecimalNumber *totalPrice = [order totalPrice];
    [self.totalAmount setText:[NSString stringWithFormat:@"%0.2f €", [totalPrice floatValue]]];

    [self refreshValues];
}

- (void)refreshValues
{
    if ([self.typingValue floatValue] == 0.00f) {
        [self.paidAmount setText:@""];
        [self.changeAmount setText:@""];
    } else {
        OrderViewController *controller = (OrderViewController *)self.parentViewController;
        Order *order = [controller order];
        NSDecimalNumber *totalPrice = [order totalPrice];
        NSDecimalNumber *changeAmount = [self.typingValue decimalNumberBySubtracting:totalPrice];

        if ([changeAmount floatValue] < 0.00f) {
            [self.changeAmount setText:@""];
            [self.changeAmount setHidden:YES];
            [self.calculationError setHidden:NO];
        } else {
            [self.changeAmount setText:[NSString stringWithFormat:@"%0.2f €", [changeAmount floatValue]]];
        }
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    [self.changeAmount setHidden:NO];
    [self.calculationError setHidden:YES];

    if (self.typingAfterComma == NO) {
        NSDecimalNumber *typedDigit = [[NSDecimalNumber alloc] initWithUnsignedInteger:[sender tag]];
        self.typingValue = [self.typingValue decimalNumberByMultiplyingByPowerOf10:1];
        self.typingValue = [self.typingValue decimalNumberByAdding:typedDigit];
    } else {
        NSDecimalNumber *typedDigit = [[NSDecimalNumber alloc] initWithFloat:(float)[sender tag] * 0.1f];
        self.typingValue = [self.typingValue decimalNumberByAdding:typedDigit];
        self.typingAfterComma = NO;
    }

    [self.paidAmount setText:[NSString stringWithFormat:@"%0.2f €", [self.typingValue floatValue]]];
    [self.changeAmount setText:@""];
}

- (IBAction)commaPressed
{
    self.typingAfterComma = YES;
}

- (IBAction)enterPressed
{
    [self refreshValues];

    self.typingValue = [NSDecimalNumber zero];
    self.typingAfterComma = NO;
}

- (IBAction)resetPressed
{
    [self.changeAmount setHidden:NO];
    [self.calculationError setHidden:YES];

    self.typingValue = [NSDecimalNumber zero];
    self.typingAfterComma = NO;

    [self.paidAmount setText:@""];
    [self.changeAmount setText:@""];
}

@end

@implementation CheckoutKeyboardButton

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [self.layer setCornerRadius:10.0f];
}

@end