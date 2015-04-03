//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Drink.h"
#import "Order.h"

@interface DrinkTableViewCell : UITableViewCell

@property (weak, nonatomic) Drink *drink;

@end

@interface DrinkTableViewPawnCupsCell : UITableViewCell

@property (weak, nonatomic) Order *order;

@end
