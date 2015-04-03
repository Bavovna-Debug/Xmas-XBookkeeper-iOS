//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Bookkeeping.h"
#import "Drink.h"

@implementation Drink

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.cup = YES;

    return self;
}

- (NSDecimalNumber *)totalPrice
{
    NSDecimalNumber *price = [[self price] copy];

    if ([self cup] == YES)
        price = [price decimalNumberByAdding:[[Bookkeeping sharedBookkeeping] cupPawnPrice]];

    return price;
}

@end

@implementation MulledWine

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    double mulledWinePrice = [[[Bookkeeping sharedBookkeeping] mulledWinePrice] doubleValue];
    self.price = [[NSDecimalNumber alloc] initWithDouble:mulledWinePrice];

    self.wineType = MulledWinePur;

    return self;
}

- (id)initFromXML:(XMLElement *)wineXML
{
    self = [super init];
    if (self == nil)
        return nil;

    NSString *price = [wineXML.attributes objectForKey:@"price"];
    self.price = [NSDecimalNumber decimalNumberWithString:price];

    NSString *cup = [wineXML.attributes objectForKey:@"cup"];
    self.cup = ([cup isEqual:@"yes"] == YES) ? YES : NO;

    NSString *wineType = [wineXML.attributes objectForKey:@"wine_type"];
    if ([wineType isEqual:@"pur"] == YES) {
        self.wineType = MulledWinePur;
    } else if ([wineType isEqual:@"with_rum"] == YES) {
        self.wineType = MulledWineWithRum;
    } else if ([wineType isEqual:@"with_amaretto"] == YES) {
        self.wineType = MulledWineWithAmaretto;
    } else if ([wineType isEqual:@"with_liqueur"] == YES) {
        self.wineType = MulledWineWithLiqueur;
    }

    return self;
}

- (XMLElement *)xml
{
    XMLElement *wineXML = [XMLElement elementWithName:@"wine"];

    [wineXML.attributes setObject:[NSString stringWithFormat:@"%0.2f", [[self price] floatValue]]
                           forKey:@"price"];

    [wineXML.attributes setObject:(self.cup == YES) ? @"yes" : @"no"
                           forKey:@"cup"];

    switch (self.wineType)
    {
        case MulledWinePur:
            [wineXML.attributes setObject:@"pur"
                                   forKey:@"wine_type"];
            break;

        case MulledWineWithRum:
            [wineXML.attributes setObject:@"with_rum"
                                   forKey:@"wine_type"];
            break;

        case MulledWineWithAmaretto:
            [wineXML.attributes setObject:@"with_amaretto"
                                   forKey:@"wine_type"];
            break;

        case MulledWineWithLiqueur:
            [wineXML.attributes setObject:@"with_liqueur"
                                   forKey:@"wine_type"];
            break;
    }

    return wineXML;
}

@end

@implementation Punch

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    double punchPrice = [[[Bookkeeping sharedBookkeeping] punchPrice] doubleValue];
    self.price = [[NSDecimalNumber alloc] initWithDouble:punchPrice];

    return self;
}

- (id)initFromXML:(XMLElement *)punchXML
{
    self = [super init];
    if (self == nil)
        return nil;

    NSString *price = [punchXML.attributes objectForKey:@"price"];
    self.price = [NSDecimalNumber decimalNumberWithString:price];

    NSString *cup = [punchXML.attributes objectForKey:@"cup"];
    self.cup = ([cup isEqual:@"YES"] == YES) ? YES : NO;

    return self;
}

- (XMLElement *)xml
{
    XMLElement *punchXML = [XMLElement elementWithName:@"punch"];

    [punchXML.attributes setObject:[NSString stringWithFormat:@"%0.2f", [[self price] floatValue]]
                            forKey:@"price"];

    [punchXML.attributes setObject:(self.cup == YES) ? @"YES" : @"NO"
                            forKey:@"cup"];

    return punchXML;
}

@end
