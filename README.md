IFGZoomCollectionViewLayout
================

A Mac OS dock like layout for UICollectionView.

Installation
------------

The simplest way to use IFGZoomCollectionViewLayout in your application is with [CocoaPods](http://cocoapods.org). See the ["Getting Started" guide for more information](http://guides.cocoapods.org/using/using-cocoapods.html).

#### Podfile

```ruby
platform :ios, '7.0'
pod "IFGZoomCollectionViewLayout", "~> 0.1.0"
```

You could instead clone the project and copy the IFGZoomCollectionViewLayout/*.{h,m} files into your project.

Usage
--------------

In order to use the IFGZoomCollectionViewLayout, just set the class of the UICollectionView layout to IFGZoomCollectionViewLayout.

Properties
-------

####cellZoomOutSize:(CGSize) - Default: 50x50

The size of the cell when it is minimized.

```objc
collectionViewLayout.cellZoomOutSize = CGSizeMake(50.0, 50.0);
```

####cellZoomInSize:(CGSize) - Default: 75x75

The size of the cell when it is maximized.

```objc
collectionViewLayout.cellZoomOutSize = CGSizeMake(75.0, 75.0);
```

####zoomDecay:(CGFloat) - Default 0.6

How fast the cells will become smaller around the center cell.

```objc
collectionViewLayout.zoomDecay = 0.6;
```

Methods
-------

####- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath;

Will scroll the collection view so as to center the item as indexPath

####- (NSIndexPath *)indexPathForItemAtOffset:(CGFloat)offset;

Returns the indexPath to the item at a given offset

IFGZoomCollectionViewLayoutAttributes
-------------

During layout, cells will receive the applyLayoutAttributes: message with a IFGZoomCollectionViewLayoutAttributes as a parameter.
The cell can then make use of the following two properties:

####zoomFactor (CGFloat)

A number greater than 1 representing the zoom factor from the cellZoomOutSize

####reductionFactor (CGFloat)

A number smaller than 1 representing the reduction factor from the cellZoomInSize


License (MIT)
-------------

Copyright (c) 2015 Emmanuel Merali

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
