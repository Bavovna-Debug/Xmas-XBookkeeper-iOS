//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Bookkeeping.h"
#import "Drink.h"
#import "Order.h"
#import "Product.h"

@implementation Order

- (id)initWithNumber:(NSUInteger)orderNumber
{
    self = [super init];
    if (self == nil)
        return nil;

    self.orderNumber      = orderNumber;
    self.timestamp        = [NSDate date];
    self.marketName       = [[Bookkeeping sharedBookkeeping] marketName];
    self.broughtPawnCups  = 0;
    self.orderedWine      = [NSMutableArray array];
    self.orderedPunch     = [NSMutableArray array];
    self.orderedProducts  = [NSMutableArray array];

    return self;
}

- (id)initFromXML:(XMLElement *)orderXML
{
    self = [super init];
    if (self == nil)
        return nil;

    NSString *orderNumber = [orderXML.attributes objectForKey:@"number"];
    self.orderNumber      = [orderNumber integerValue];

    NSString *reported    = [orderXML.attributes objectForKey:@"reported"];
    self.reported         = ([reported isEqual:@"yes"] == YES) ? YES : NO;

    NSString *unixTimestamp = [orderXML.attributes objectForKey:@"timestamp"];
    NSTimeInterval since1970 = [unixTimestamp doubleValue];
    self.timestamp = [NSDate dateWithTimeIntervalSince1970:since1970];

    self.marketName = [orderXML.attributes objectForKey:@"market_name"];
    NSString *broughtPawnCups = [orderXML.attributes objectForKey:@"pawn_cups"];
    self.broughtPawnCups  = [broughtPawnCups integerValue];

    self.orderedWine      = [NSMutableArray array];
    self.orderedPunch     = [NSMutableArray array];
    self.orderedProducts  = [NSMutableArray array];

    for (XMLElement *element in [orderXML elements])
    {
        if ([element.name isEqualToString:@"ordered_wine"] == YES) {
            for (XMLElement *wineXML in [element elements])
            {
                MulledWine *wine = [[MulledWine alloc] initFromXML:wineXML];
                [self.orderedWine addObject:wine];
            }
        } else if ([element.name isEqualToString:@"ordered_punch"] == YES) {
            for (XMLElement *punchXML in [element elements])
            {
                Punch *punch = [[Punch alloc] initFromXML:punchXML];
                [self.orderedPunch addObject:punch];
            }
        } else if ([element.name isEqualToString:@"ordered_products"] == YES) {
            for (XMLElement *productXML in [element elements])
            {
                Product *product = [[Product alloc] initFromXML:productXML];
                [self.orderedProducts addObject:product];
            }
        }
    }

    return self;
}

- (XMLElement *)xml
{
    XMLElement *orderXML = [XMLElement elementWithName:@"order"];

    NSString *orderNumber = [NSString stringWithFormat:@"%lu", (unsigned long)self.orderNumber];
    [orderXML.attributes setObject:orderNumber
                            forKey:@"number"];

    NSString *reported = (self.reported == NO) ? @"no" : @"yes";
    [orderXML.attributes setObject:reported
                            forKey:@"reported"];

    NSTimeInterval since1970 = [self.timestamp timeIntervalSince1970];
    NSString *unixTimestamp = [NSString stringWithFormat:@"%.0f", since1970];
    [orderXML.attributes setObject:unixTimestamp
                            forKey:@"timestamp"];

    [orderXML.attributes setObject:self.marketName
                            forKey:@"market_name"];

    NSString *broughtPawnCups = [NSString stringWithFormat:@"%lu", (unsigned long)self.broughtPawnCups];
    [orderXML.attributes setObject:broughtPawnCups
                            forKey:@"pawn_cups"];

    if ([self.orderedWine count] > 0) {
        XMLElement *orderedWineXML = [XMLElement elementWithName:@"ordered_wine"];

        for (MulledWine *wine in self.orderedWine)
        {
            XMLElement *wineXML = [wine xml];
            [orderedWineXML addElement:wineXML];
        }

        [orderXML addElement:orderedWineXML];
    }

    if ([self.orderedPunch count] > 0) {
        XMLElement *orderedPunchXML = [XMLElement elementWithName:@"ordered_punch"];

        for (Punch *punch in self.orderedPunch)
        {
            XMLElement *punchXML = [punch xml];
            [orderedPunchXML addElement:punchXML];
        }

        [orderXML addElement:orderedPunchXML];
    }

    if ([self.orderedProducts count] > 0) {
        XMLElement *orderedProductsXML = [XMLElement elementWithName:@"ordered_products"];

        for (Product *product in self.orderedProducts)
        {
            XMLElement *productXML = [product xml];
            [orderedProductsXML addElement:productXML];
        }

        [orderXML addElement:orderedProductsXML];
    }

    return orderXML;
}

- (void)orderChanged
{
    if (self.delegate != nil)
        [self.delegate orderChanged:self];
}

- (NSDecimalNumber *)totalPrice
{
    NSDecimalNumber *totalPrice = [NSDecimalNumber zero];

    for (Drink *drink in self.orderedWine)
        totalPrice = [totalPrice decimalNumberByAdding:[drink totalPrice]];

    for (Drink *drink in self.orderedPunch)
        totalPrice = [totalPrice decimalNumberByAdding:[drink totalPrice]];

    if (self.broughtPawnCups != 0) {
        double cupPawnPrice = [[[Bookkeeping sharedBookkeeping] cupPawnPrice] doubleValue];
        NSDecimalNumber *pawnPrice = [[NSDecimalNumber alloc] initWithDouble:self.broughtPawnCups * cupPawnPrice];
        totalPrice = [totalPrice decimalNumberBySubtracting:pawnPrice];
    }

    for (Product *product in self.orderedProducts)
        totalPrice = [totalPrice decimalNumberByAdding:[product price]];

    return totalPrice;
}

@end
