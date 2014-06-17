//
// Created by Akinori ADACHI on 2014/06/14.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEMatrix.h"


@implementation MEMatrix

- (id)initWithX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z {
    if (self = [super init]) {
        [self setX:x Y:y Z:z];
    }
    return self;
}

- (void)setX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z{
    _x = x;
    _y = y;
    _z = z;
}

@end