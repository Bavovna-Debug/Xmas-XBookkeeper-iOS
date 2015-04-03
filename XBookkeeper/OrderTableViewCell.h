//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Order.h"

@interface AddOrderTableViewCell : UITableViewCell

@end

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) Order *order;

- (void)refreshValues;

@end
