//
//  SCViewController.h
//  SpringyCarousel
//
//  Created by Sam Davies on 15/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)newViewButtonPressed:(id)sender;

@end
