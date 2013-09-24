//
//  SCTrafficStatusTableCell.h
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTrafficStatusTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorBlock;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;

@end
