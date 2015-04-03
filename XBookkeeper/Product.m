//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithPrice:(NSDecimalNumber *)price
{
    self = [super init];
    if (self == nil)
        return nil;

    self.price = price;

    return self;
}

- (id)initFromXML:(XMLElement *)productXML
{
    self = [super init];
    if (self == nil)
        return nil;

    NSString *price = [productXML.attributes objectForKey:@"price"];
    self.price = [NSDecimalNumber decimalNumberWithString:price];

    return self;
}

- (XMLElement *)xml
{
    XMLElement *productXML = [XMLElement elementWithName:@"product"];

    NSString *price = [NSString stringWithFormat:@"%0.2f", [self.price floatValue]];
    [productXML.attributes setObject:price
                              forKey:@"price"];

    return productXML;
}

@end
