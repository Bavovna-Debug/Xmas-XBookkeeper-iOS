//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XML.h"

@interface Product : NSObject

@property (strong, nonatomic) NSDecimalNumber *price;

- (id)initWithPrice:(NSDecimalNumber *)price;

- (id)initFromXML:(XMLElement *)productXML;

- (XMLElement *)xml;

@end
