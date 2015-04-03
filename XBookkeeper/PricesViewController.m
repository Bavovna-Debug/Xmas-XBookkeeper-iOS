//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Bookkeeping.h"
#import "PricesViewController.h"

@interface PricesViewController ()

@property (weak, nonatomic) IBOutlet UITextField *marketName;
@property (weak, nonatomic) IBOutlet UILabel *winePrice;
@property (weak, nonatomic) IBOutlet UILabel *punchPrice;
@property (weak, nonatomic) IBOutlet UILabel *cupPawnPrice;

@end

@implementation PricesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refreshValues];
}

- (IBAction)marketNameChanged
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    [bookkeeping setMarketName:[self.marketName text]];

    [bookkeeping savePrices];
}

- (void)refreshValues
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    [self.marketName setText:[bookkeeping marketName]];
    [self.winePrice setText:[NSString stringWithFormat:@"%0.2f €", [[bookkeeping mulledWinePrice] floatValue]]];
    [self.punchPrice setText:[NSString stringWithFormat:@"%0.2f €", [[bookkeeping punchPrice] floatValue]]];
    [self.cupPawnPrice setText:[NSString stringWithFormat:@"%0.2f €", [[bookkeeping cupPawnPrice] floatValue]]];
}

- (IBAction)winePriceDecrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setMulledWinePrice:[[bookkeeping mulledWinePrice] decimalNumberBySubtracting:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

- (IBAction)winePriceIncrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setMulledWinePrice:[[bookkeeping mulledWinePrice] decimalNumberByAdding:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

- (IBAction)punchPriceDecrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setPunchPrice:[[bookkeeping punchPrice] decimalNumberBySubtracting:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

- (IBAction)punchPriceIncrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setPunchPrice:[[bookkeeping punchPrice] decimalNumberByAdding:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

- (IBAction)cupPawnPriceDecrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setCupPawnPrice:[[bookkeeping cupPawnPrice] decimalNumberBySubtracting:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

- (IBAction)cupPawnPriceIncrease
{
    Bookkeeping *bookkeeping = [Bookkeeping sharedBookkeeping];

    NSDecimalNumber *delta = [[NSDecimalNumber alloc] initWithFloat:0.10f];
    [bookkeeping setCupPawnPrice:[[bookkeeping cupPawnPrice] decimalNumberByAdding:delta]];

    [bookkeeping savePrices];

    [self refreshValues];
}

@end
