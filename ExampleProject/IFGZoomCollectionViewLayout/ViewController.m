//
//  ViewController.m
//  IFGZoomCollectionViewLayout
//
//  Created by Emmanuel Merali on 12/07/2015.
//  Copyright (c) 2015 ifullgaz.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView       *collectionView;
@property (weak, nonatomic) IBOutlet UILabel                *label;

@end

@interface ViewController (Private)

- (void)updateDetailsFromSelectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ViewController (UICollectionViewDelegate) <UICollectionViewDataSource, UICollectionViewDelegate>

@end


@implementation ViewController (UICollectionViewDelegate)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    switch (indexPath.row % 3) {
        case 0:
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor redColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor greenColor];
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    IFGZoomCollectionViewLayout *layout = (IFGZoomCollectionViewLayout *)collectionView.collectionViewLayout;
    [layout scrollToItemAtIndexPath:indexPath];
    [self updateDetailsFromSelectionAtIndexPath:indexPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    IFGZoomCollectionViewLayout *layout = (IFGZoomCollectionViewLayout *)self.collectionView.collectionViewLayout;
    NSIndexPath *indexPath = [layout indexPathForItemAtOffset:scrollView.contentOffset.x];
    [self updateDetailsFromSelectionAtIndexPath:indexPath];
}

@end

@implementation ViewController (Private)

- (void)updateDetailsFromSelectionAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row % 3) {
        case 0:
            self.label.text = @"Yellow";
            break;
        case 1:
            self.label.text = @"Red";
            break;
        case 2:
            self.label.text = @"Green";
            break;
    }
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateDetailsFromSelectionAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
