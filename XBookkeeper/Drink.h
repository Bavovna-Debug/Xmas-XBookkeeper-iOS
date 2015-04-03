//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XML.h"

@interface Drink : NSObject

@property (strong, nonatomic) NSDecimalNumber *price;
@property (assign, nonatomic) Boolean cup;

- (NSDecimalNumber *)totalPrice;

@end

@interface MulledWine : Drink

typedef enum
{
    MulledWinePur,
    MulledWineWithRum,
    MulledWineWithAmaretto,
    MulledWineWithLiqueur
} WineType;

@property (assign, nonatomic) WineType wineType;

- (id)initFromXML:(XMLElement *)wineXML;

- (XMLElement *)xml;

@end

@interface Punch : Drink

- (id)initFromXML:(XMLElement *)punchXML;

- (XMLElement *)xml;

@end
