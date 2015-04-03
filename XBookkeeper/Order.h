//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XML.h"

@protocol OrderDelegate;

@interface Order : NSObject

@property (strong, nonatomic, readwrite) id<OrderDelegate> delegate;

@property (assign, nonatomic) NSUInteger     orderNumber;
@property (assign, nonatomic) Boolean        reported;
@property (strong, nonatomic) NSDate         *timestamp;
@property (strong, nonatomic) NSString       *marketName;
@property (assign, nonatomic) NSUInteger     broughtPawnCups;
@property (strong, nonatomic) NSMutableArray *orderedWine;
@property (strong, nonatomic) NSMutableArray *orderedPunch;
@property (strong, nonatomic) NSMutableArray *orderedProducts;

- (id)initWithNumber:(NSUInteger)orderNumber;

- (id)initFromXML:(XMLElement *)orderXML;

- (XMLElement *)xml;

- (void)orderChanged;

- (NSDecimalNumber *)totalPrice;

@end

@protocol OrderDelegate <NSObject>

@required

- (void)orderChanged:(Order *)order;

@end