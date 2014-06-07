//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEGameParts.h"


@implementation MEGameParts

- (id)initWithParams:(BOOL)walkable1 imageView:(NSImageView*)imageView1 customEvents:(NSDictionary *)customEvents1{
    if(self = [super init]){
        walkable = walkable1;
        self.imageView = imageView1;
        customEvents = customEvents1;
    }
    return self;
}

@end