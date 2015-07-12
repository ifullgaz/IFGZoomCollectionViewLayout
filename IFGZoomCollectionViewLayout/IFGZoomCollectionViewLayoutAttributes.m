//
//  IFGZoomCollectionViewLayoutAttributes.m
//  Who Loves Me
//
//  Created by Emmanuel Merali on 05/07/2015.
//  Copyright (c) 2015 pitnpack. All rights reserved.
//

#import "IFGZoomCollectionViewLayoutAttributes.h"

@implementation IFGZoomCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    IFGZoomCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.zoomFactor = self.zoomFactor;
    newAttributes.reductionFactor = self.reductionFactor;
    return newAttributes;
}

- (BOOL)isEqual:(id)object {
    IFGZoomCollectionViewLayoutAttributes *otherAttributes = (IFGZoomCollectionViewLayoutAttributes *)object;
    if (otherAttributes.zoomFactor == self.zoomFactor &&
        otherAttributes.reductionFactor == self.reductionFactor) {
        return [super isEqual:object];
    }
    return FALSE;
}

@end
