//
//  MEGameMapChipLayer.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/19.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class MEGameParts;
@class MEMatrix;

@interface MEGameMapChipLayer : CALayer

@property MEGameParts *gameParts;
@property CGFloat aspectX;
@property CGFloat aspectY;
@property CGFloat aspectT;

- (id)initWithGameParts:(MEGameParts *)gameParts1 x:(CGFloat)aspectX y:(CGFloat)aspectY t:(CGFloat)aspectT ;

- (void)drawEmptyCursor;
- (void)drawFlag:(BOOL)isEnemy;

- (void)drawCurrentCursor;

- (void)drawGameParts;
+ (BOOL)hitCursorPointWithMatrix:(MEMatrix *)matrix
                         aspectX:(CGFloat)aspectX
                         aspectY:(CGFloat)aspectY
                             aid:(CGFloat)aid
                     mouseCursor:(CGPoint)cursorPoint
                    chipPosition:(CGPoint)chipPoint;

@end
