//
//  SCViewController.h
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UITableViewController

- (NSUInteger)insertStatusObjectsForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
