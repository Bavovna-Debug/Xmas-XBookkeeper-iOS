//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Order.h"

@interface Bookkeeping : NSObject

@property (strong, nonatomic) NSString        *marketName;
@property (strong, nonatomic) NSDecimalNumber *mulledWinePrice;
@property (strong, nonatomic) NSDecimalNumber *punchPrice;
@property (strong, nonatomic) NSDecimalNumber *cupPawnPrice;

@property (strong, nonatomic) NSMutableArray *orders;
@property (assign, nonatomic) NSUInteger     lastOrderNumber;

+ (Bookkeeping *)sharedBookkeeping;

- (void)addNewOrder;

- (void)savePrices;

- (void)loadPrices;

- (void)saveOrders;

- (void)loadOrders;

@end
