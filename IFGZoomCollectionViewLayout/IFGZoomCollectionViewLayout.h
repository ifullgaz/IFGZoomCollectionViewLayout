//
//  IFGZoomCollectionViewLayout.h
//  Who Loves Me
//
//  Created by Emmanuel Merali on 05/07/2015.
//  Copyright (c) 2015 pitnpack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFGZoomCollectionViewLayout : UICollectionViewLayout

@property (assign, nonatomic) CGSize                        cellZoomInSize;
@property (assign, nonatomic) CGSize                        cellZoomOutSize;
@property (assign, nonatomic) CGFloat                       zoomDecay;

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForItemAtOffset:(CGFloat)offset;

@end
