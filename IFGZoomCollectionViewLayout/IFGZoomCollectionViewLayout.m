//
//  IFGZoomCollectionViewLayout.m
//  Who Loves Me
//
//  Created by Emmanuel Merali on 05/07/2015.
//  Copyright (c) 2015 pitnpack. All rights reserved.
//

#import "IFGZoomCollectionViewLayout.h"
#import "IFGZoomCollectionViewLayoutAttributes.h"

@interface IFGZoomCollectionViewLayout ()

@property (strong, nonatomic) NSDictionary                  *layoutAttributes;
@property (assign, nonatomic) CGFloat                       contentSizeWidth;
@property (assign, nonatomic) CGFloat                       lastZoomFactor;
@property (assign, nonatomic) CGFloat                       lastReductionFactor;

@end

@interface IFGZoomCollectionViewLayout (Private)

- (void)postInitialization;
- (NSInteger)cellIndexAtOffset:(CGFloat)offset;
- (CGFloat)offsetRatioAtIndex:(NSInteger)index offset:(CGFloat)offset;
- (CGFloat)zoomFactor:(CGFloat)offsetRatio;
- (CGSize)zoomedSize:(NSInteger)index offset:(CGFloat)offset;
- (CGFloat)relativeDisplacementAtIndex:(NSInteger)index offset:(CGFloat)offset;
- (CGRect)zoomedFrame:(NSInteger)index offset:(CGFloat)offset;

@end


@implementation IFGZoomCollectionViewLayout (Private)

- (void)postInitialization {
    self.cellZoomInSize = CGSizeMake(75.0, 75.0);
    self.cellZoomOutSize = CGSizeMake(50.0, 50.0);
    self.zoomDecay = 0.6;
}

- (NSInteger)cellIndexAtOffset:(CGFloat)offset {
    return (offset + self.cellZoomOutSize.width / 2.0) / self.cellZoomOutSize.width;
}

- (CGFloat)offsetRatioAtIndex:(NSInteger)index offset:(CGFloat)offset {
    CGFloat offsetRatio = (self.cellZoomOutSize.width * index - offset) / self.cellZoomOutSize.width;
    return offsetRatio;
}

- (CGFloat)zoomFactor:(CGFloat)offsetRatio {
    CGFloat zoom = exp(-(offsetRatio*offsetRatio)/self.zoomDecay);
    return zoom;
}

- (CGSize)zoomedSize:(NSInteger)index offset:(CGFloat)offset {
    CGFloat offsetRatio = [self offsetRatioAtIndex:index offset:offset];
    self.lastZoomFactor = [self zoomFactor:offsetRatio];
    CGSize newSize = CGSizeMake(
                                self.cellZoomOutSize.width + (self.cellZoomInSize.width - self.cellZoomOutSize.width) * self.lastZoomFactor,
                                self.cellZoomOutSize.height + (self.cellZoomInSize.height - self.cellZoomOutSize.height) * self.lastZoomFactor);
    self.lastReductionFactor = newSize.width / self.cellZoomInSize.width;
    return newSize;
}

- (CGFloat)relativeDisplacementAtIndex:(NSInteger)index offset:(CGFloat)offset {
    CGFloat relativeDisplacement = (self.cellZoomOutSize.width / 2.0 + offset - self.cellZoomOutSize.width * index) / self.cellZoomOutSize.width;
    return relativeDisplacement;
}

- (CGRect)zoomedFrame:(NSInteger)index offset:(CGFloat)offset {
    CGSize zoomedSize = [self zoomedSize:index offset:offset];
    CGFloat relativeDisplacement = [self relativeDisplacementAtIndex:index offset:offset];
    CGRect frame = CGRectMake(
                              self.collectionView.frame.size.width / 2.0 + offset - zoomedSize.width * relativeDisplacement,
                              self.collectionView.frame.size.height - zoomedSize.height,
                              zoomedSize.width,
                              zoomedSize.height);
    return frame;
}

@end

@implementation IFGZoomCollectionViewLayout

+ (Class)layoutAttributesClass {
    return [IFGZoomCollectionViewLayoutAttributes class];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize some defaults
        [self postInitialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self postInitialization];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableDictionary *layoutAttributes = [NSMutableDictionary dictionary];
    NSMutableArray *frames = [NSMutableArray array];
    self.contentSizeWidth = 0.0;

    NSInteger numberOfSections = [self.collectionView numberOfSections];
    // Initial pass: create all attributes
    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            [frames addObject:[IFGZoomCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath]];
        }
    }
    NSInteger numberOfItems = [frames count];
    if (numberOfItems) {
        // Second pass: adjust zoomed frame and all others around it
        CGFloat xOffset = self.collectionView.contentOffset.x;
        NSInteger currentCellIndex = [self cellIndexAtOffset:xOffset];
        NSInteger zoomedCellIndex = MIN(MAX(0, (NSInteger)currentCellIndex), [frames count] - 1);
        IFGZoomCollectionViewLayoutAttributes *attributes = [frames objectAtIndex:zoomedCellIndex];
        CGRect zoomedCellframe = [self zoomedFrame:zoomedCellIndex offset:xOffset];
        attributes.frame = zoomedCellframe;
        attributes.zoomFactor = self.lastZoomFactor;
        attributes.reductionFactor = self.lastReductionFactor;
        attributes.zIndex = zoomedCellIndex;
        [layoutAttributes setObject:attributes forKey:attributes.indexPath];
        self.contentSizeWidth+= zoomedCellframe.size.width;
        CGFloat lastX = zoomedCellframe.origin.x;
        for (NSInteger index = zoomedCellIndex - 1; index >= 0; index--) {
            CGSize size = [self zoomedSize:index offset:xOffset];
            CGRect frame = CGRectMake(
                               lastX - size.width,
                               self.collectionView.frame.size.height - size.height,
                               size.width,
                               size.height);
            attributes = [frames objectAtIndex:index];
            attributes.frame = frame;
            attributes.zoomFactor = self.lastZoomFactor;
            attributes.reductionFactor = self.lastReductionFactor;
            attributes.zIndex = index;
            [layoutAttributes setObject:attributes forKey:attributes.indexPath];
            lastX = frame.origin.x;
            self.contentSizeWidth+= size.width;
        }
        lastX = zoomedCellframe.origin.x + zoomedCellframe.size.width;
        for (NSInteger index = zoomedCellIndex + 1; index < numberOfItems; index++) {
            CGSize size = [self zoomedSize:index offset:xOffset];
            CGRect frame = CGRectMake(
                               lastX,
                               self.collectionView.frame.size.height - size.height,
                               size.width,
                               size.height);
            attributes = [frames objectAtIndex:index];
            attributes.frame = frame;
            attributes.zoomFactor = self.lastZoomFactor;
            attributes.reductionFactor = self.lastReductionFactor;
            attributes.zIndex = index;
            [layoutAttributes setObject:attributes forKey:attributes.indexPath];
            lastX+= size.width;
            self.contentSizeWidth+= size.width;
        }
    }
    self.layoutAttributes = [NSDictionary dictionaryWithDictionary:layoutAttributes];
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfItems = [self.layoutAttributes count];
    return CGSizeMake(self.cellZoomOutSize.width * (numberOfItems - 1) + self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // create layouts for the rectangles in the view
    NSMutableArray *attributesInRect =  [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in [self.layoutAttributes allValues]) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesInRect addObject:attributes];
        }
    }
    
    return attributesInRect;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat proposedPageIndex = roundf(proposedContentOffset.x / self.cellZoomOutSize.width);
    CGFloat nearestPageOffset = proposedPageIndex * self.cellZoomOutSize.width;
    return CGPointMake(nearestPageOffset, proposedContentOffset.y);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[indexPath];
}

// bounds change causes prepareLayout if YES
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath {
    IFGZoomCollectionViewLayoutAttributes *attributes = (IFGZoomCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat offset = attributes.zIndex * self.cellZoomOutSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0.0) animated:YES];
}

- (NSIndexPath *)indexPathForItemAtOffset:(CGFloat)offset {
    NSInteger currentCellIndex = [self cellIndexAtOffset:offset];
    NSInteger zoomedCellIndex = MIN(MAX(0, (NSInteger)currentCellIndex), [self.layoutAttributes count] - 1);
    for (UICollectionViewLayoutAttributes *attributes in [self.layoutAttributes allValues]) {
        if (attributes.zIndex == zoomedCellIndex) {
            return attributes.indexPath;
        }
    }
    return nil;
}

@end
