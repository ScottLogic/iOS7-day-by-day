//
//  SCLabelledImageCell.h
//  ImageFilter
//
//  Created by Sam Davies on 08/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLabelledImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
