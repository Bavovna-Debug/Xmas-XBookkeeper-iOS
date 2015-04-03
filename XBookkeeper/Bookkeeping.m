//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Bookkeeping.h"
#import "Drink.h"
#import "Product.h"
#import "XML.h"

#define XmasTarget   @"x-mas"
#define XmasVersion  @"1.0"
#define OrdersKey    @"Orders"
#define PricesKey    @"Prices"

@implementation Bookkeeping

+ (Bookkeeping *)sharedBookkeeping
{
    static dispatch_once_t onceToken;
    static Bookkeeping *bookkeeping;

    dispatch_once(&onceToken, ^{
        bookkeeping = [[Bookkeeping alloc] init];
    });

    return bookkeeping;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.mulledWinePrice = [NSDecimalNumber zero];
    self.punchPrice = [NSDecimalNumber zero];
    self.cupPawnPrice = [NSDecimalNumber zero];

    self.orders = [NSMutableArray array];
    self.lastOrderNumber = 250;

    return self;
}

- (void)addNewOrder
{
    [self saveOrders];

    self.lastOrderNumber++;
    Order *order = [[Order alloc] initWithNumber:self.lastOrderNumber];
    [self.orders insertObject:order
                      atIndex:0];

    //[self reportToServer];
}

#pragma mark - XML

- (void)savePrices
{
    XMLDocument *document = [XMLDocument documentWithTarget:XmasTarget
                                                    version:XmasVersion];

    XMLElement *pricesXML = [XMLElement elementWithName:@"prices"];

    [document setForest:pricesXML];

    [pricesXML.attributes setObject:self.marketName
                             forKey:@"market_name"];

    NSString *winePrice = [NSString stringWithFormat:@"%@", [self.mulledWinePrice stringValue]];
    [pricesXML.attributes setObject:winePrice
                             forKey:@"wine"];

    NSString *punchPrice = [NSString stringWithFormat:@"%@", [self.punchPrice stringValue]];
    [pricesXML.attributes setObject:punchPrice
                             forKey:@"punch"];

    NSString *cupPawnPrice = [NSString stringWithFormat:@"%@", [self.cupPawnPrice stringValue]];
    [pricesXML.attributes setObject:cupPawnPrice
                             forKey:@"cup_pawn"];

    NSData *pricesData = [document xmlData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pricesData
                 forKey:PricesKey];
    [defaults synchronize];
}

- (void)loadPrices
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *pricesData = [defaults objectForKey:PricesKey];

    XMLDocument *document = [XMLDocument documentFromData:pricesData];

    XMLElement *pricesXML = [document forest];

    self.marketName = [pricesXML.attributes objectForKey:@"market_name"];

    NSString *winePrice = [pricesXML.attributes objectForKey:@"wine"];
    if (winePrice == nil)
        self.mulledWinePrice = [NSDecimalNumber zero];
    else
        self.mulledWinePrice = [NSDecimalNumber decimalNumberWithString:winePrice];

    NSString *punchPrice = [pricesXML.attributes objectForKey:@"punch"];
    if (punchPrice == nil)
        self.punchPrice = [NSDecimalNumber zero];
    else
        self.punchPrice = [NSDecimalNumber decimalNumberWithString:punchPrice];

    NSString *cupPawnPrice = [pricesXML.attributes objectForKey:@"cup_pawn"];
    if (cupPawnPrice == nil)
        self.cupPawnPrice = [NSDecimalNumber zero];
    else
        self.cupPawnPrice = [NSDecimalNumber decimalNumberWithString:cupPawnPrice];
}

- (void)saveOrders
{
    XMLDocument *document = [XMLDocument documentWithTarget:XmasTarget
                                                    version:XmasVersion];

    XMLElement *ordersXML = [XMLElement elementWithName:@"orders"];

    [document setForest:ordersXML];

    NSString *lastOrderNumber = [NSString stringWithFormat:@"%lu", (unsigned long)self.lastOrderNumber];
    [ordersXML.attributes setObject:lastOrderNumber
                             forKey:@"last_order_number"];

    for (Order *order in self.orders)
    {
        XMLElement *orderXML = [order xml];
        [ordersXML addElement:orderXML];
    }

    NSData *ordersData = [document xmlData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ordersData
                 forKey:OrdersKey];
    [defaults synchronize];
}

- (void)loadOrders
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *ordersData = [defaults objectForKey:OrdersKey];

    XMLDocument *document = [XMLDocument documentFromData:ordersData];

    XMLElement *ordersXML = [document forest];

    NSString *lastOrderNumber = [ordersXML.attributes objectForKey:@"last_order_number"];
    self.lastOrderNumber      = [lastOrderNumber integerValue];

    for (XMLElement *orderXML in [ordersXML elements])
    {
        Order *order = [[Order alloc] initFromXML:orderXML];
        [self.orders addObject:order];
    }
}

- (void)reportToServer
{
    for (Order *order in self.orders)
    {
        if ([order orderNumber] == self.lastOrderNumber)
            continue;

        if ([order reported] == NO) {
            NSString             *serverName;
            NSString             *parameters;
            NSURL                *url;
            NSMutableURLRequest  *serviceRequest;
            NSHTTPURLResponse    *response;
            NSError              *error;
            NSData               *responseData;

            NSString *timestamp = [NSDateFormatter localizedStringFromDate:[order timestamp]
                                                                 dateStyle:NSDateFormatterNoStyle
                                                                 timeStyle:NSDateFormatterMediumStyle];

            serverName = @"heim.zeppelinium.de:2014";
            parameters = [NSString stringWithFormat:@"order_id=%lu&timestamp=%@&xml=%@",
                          (unsigned long)[order orderNumber],
                          timestamp,
                          [self reportForOrder:order]];
            NSLog(@"%@ %@", serverName, parameters);

            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/order?%@", serverName, parameters]];
            serviceRequest = [NSMutableURLRequest requestWithURL:url];
            [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
            [serviceRequest setHTTPMethod:@"POST"];

            responseData = [NSURLConnection sendSynchronousRequest:serviceRequest
                                                 returningResponse:&response
                                                             error:&error];
            if (!responseData) {
                NSLog(@"Cannot report order %lu - %@", (unsigned long)[order orderNumber], error);
            } else {
                if ([response statusCode] == 500) {
                    NSLog(@"Error 500 for order %lu - %@", (unsigned long)[order orderNumber], error);
                } else {
                    NSLog(@"%@", response);
                    [order setReported:YES];
                }
            }
        }
    }
}

- (NSString *)reportForOrder:(Order *)order
{
    NSString         *timestamp;
    NSDecimalNumber  *totalPrice = [NSDecimalNumber zero];

    timestamp = [NSDateFormatter localizedStringFromDate:[order timestamp]
                                               dateStyle:NSDateFormatterNoStyle
                                               timeStyle:NSDateFormatterMediumStyle];

    NSString *report = [NSString stringWithFormat:@"%lu - %0.2f -",
                        (unsigned long)[order orderNumber],
                        [[self saldo] floatValue]];

    for (MulledWine *wine in [order orderedWine])
    {
        switch ([wine wineType])
        {
            case MulledWinePur:
                report = [report stringByAppendingString:@" W"];
                break;
                
            case MulledWineWithRum:
                report = [report stringByAppendingString:@" R"];
                break;

            case MulledWineWithAmaretto:
                report = [report stringByAppendingString:@" A"];
                break;

            case MulledWineWithLiqueur:
                report = [report stringByAppendingString:@" L"];
                break;
        }
    }

    for (Punch *punch in [order orderedPunch])
    {
        report = [report stringByAppendingString:@" P"];
    }

    for (Product *product in [order orderedProducts])
    {
        report = [report stringByAppendingString:@" S"];
    }

    totalPrice = [order totalPrice];

    double cupPawnPrice = [[[Bookkeeping sharedBookkeeping] cupPawnPrice] doubleValue];
    NSDecimalNumber *pawnPrice = [[NSDecimalNumber alloc] initWithDouble:[order broughtPawnCups] * cupPawnPrice];

    totalPrice = [totalPrice decimalNumberBySubtracting:pawnPrice];

    report = [report stringByAppendingString:[NSString stringWithFormat:@" - %0.2f", [totalPrice floatValue]]];

    report = [report xml];

    report = [report stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];

    return report;
}

- (NSDecimalNumber *)saldo
{
    NSDecimalNumber *saldo;

    for (Order *order in self.orders)
    {
        saldo = [saldo decimalNumberByAdding:[order totalPrice]];
        double cupPawnPrice = [[[Bookkeeping sharedBookkeeping] cupPawnPrice] doubleValue];
        NSDecimalNumber *pawnPrice = [[NSDecimalNumber alloc] initWithDouble:[order broughtPawnCups] * cupPawnPrice];
        saldo = [saldo decimalNumberBySubtracting:pawnPrice];
    }

    return saldo;
}

@end
