//
//  X-mas Bookkeeper
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookkeeperAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow     *window;
@property (weak,   nonatomic) UITableView  *ordersTableView;

- (void)currentOrderChanged;

@end

@interface RoundCornerButton : UIButton

@end
