//
//  SCViewController.m
//  SpringyCarousel
//
//  Created by Sam Davies on 15/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCSpringyCarousel.h"
#import "SCCollectionViewSampleCell.h"

@interface SCViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionViewFlowLayout *_collectionViewLayout;
    NSMutableArray *_collectionViewCellContent;
    CGSize itemSize;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    itemSize = CGSizeMake(70, 70);
    
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareSpringyCarousel];
    
    // Create the cells
    [self createCells];
}

- (void)prepareSpringyCarousel
{
    // Provide the layout
    _collectionViewLayout = [[SCSpringyCarousel alloc] initWithItemSize:itemSize];
    self.collectionView.collectionViewLayout = _collectionViewLayout;
    
    // Set datasource and delegate
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)createCells
{
    _collectionViewCellContent = [NSMutableArray array];
    for (int i=0; i<30; i++) {
        [_collectionViewCellContent addObject:@(i)];
    }
}


#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionViewCellContent count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SCCollectionViewSampleCell *cell = (SCCollectionViewSampleCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"SpringyCell" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", [_collectionViewCellContent[indexPath.row] integerValue]];
    return cell;
}


#pragma mark - UICollectionViewDelegate methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return itemSize;
}

@end
