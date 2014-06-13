//
//  MEGamePartsViewItem.m
//  qMapEditor
//
//  Created by Akinori ADACHI on 2014/06/10.
//  Copyright (c) 2014年 regalia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MEGamePartsViewItem.h"
#import "MEGameParts.h"

@interface MEGamePartsViewItem ()

@end

@implementation MEGamePartsViewItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"aho rep:%@", self.representedObject);
        [self addObserver:self
               forKeyPath:@"view"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        [self addObserver:self
               forKeyPath:@"representedObject.game_parts.tiles"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"hello");
    [self runAnimation];
}

- (void)runAnimation {
//    [CATransaction begin];
    MEGameParts *parts = [self.representedObject objectForKey:@"game_parts"];
    [self.imageView setWantsLayer:YES];

    CALayer* animationLayer = [CALayer layer];
    animationLayer.frame = self.imageView.bounds;
    [self.imageView.layer addSublayer:animationLayer];
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];

    NSMutableArray *array = [NSMutableArray array];
    CGImageRef maskRef;
    for (METile *tile in parts.tiles) {
        NSImage *someImage = [tile image];
        CGImageSourceRef source;
        source = CGImageSourceCreateWithData((__bridge CFDataRef) [someImage TIFFRepresentation], NULL);
        maskRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        [array addObject:(__bridge id) (maskRef)];
    }

    NSLog(@"array:%@",array);
    keyAnimation.values = (NSArray*)array;
    keyAnimation.duration = 1.0f;
    keyAnimation.repeatCount = HUGE_VALF;
    [keyAnimation setCalculationMode: kCAAnimationDiscrete];

    [animationLayer addAnimation:keyAnimation forKey:@"aho"];
}

- (void)mouseDown:(NSEvent *)theEvent {
    //選択状態にする
    NSLog(@"item mouseDown");
    NSDictionary *item = [NSDictionary dictionaryWithObject:self.representedObject
                                                     forKey:@"KEY"];
    NSNotification *n =
            [NSNotification notificationWithName:@"selectedGameParts" object:self userInfo:item];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)setSelected:(BOOL)flag {
    [super setSelected:flag];
    NSLog(@"item selected");
}

@end
