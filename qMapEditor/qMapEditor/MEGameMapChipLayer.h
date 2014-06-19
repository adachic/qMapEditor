//
//  MEGameMapChipLayer.h
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/19.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class MEGameParts;

@interface MEGameMapChipLayer : CALayer

@property MEGameParts *gameParts;
@property NSInteger aspectX;
@property NSInteger aspectY;
@property NSInteger aspectT;

- (id)initWithGameParts:(MEGameParts *)gameParts1 x:(int)aspectX y:(int)aspectY t:(int)aspectT;

- (void)drawEmptyCursor;
- (void)drawCurrentCursor;

@end
