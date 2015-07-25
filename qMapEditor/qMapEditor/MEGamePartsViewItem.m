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
    [self updateImageView2];
    [self runAnimation];
}

- (void)updateImageView2{
    MEGameParts *parts = [self.representedObject objectForKey:@"game_parts"];
    [self.imageView2 setWantsLayer:YES];
    self.imageView2.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    for(CALayer *layer in [self.imageView2.layer.sublayers mutableCopy]){
        [layer removeFromSuperlayer];
    }
    
    if (parts.walkable) {
        CALayer *sublayer = [CALayer layer];
        sublayer.backgroundColor = [NSColor blueColor].CGColor;
        sublayer.frame = CGRectMake(0, 0, 10, 10);
        [self.imageView2.layer addSublayer:sublayer];
    }
    if (parts.half) {
        CALayer *sublayer2 = [CALayer layer];
        sublayer2.backgroundColor = [NSColor orangeColor].CGColor;
        sublayer2.frame = CGRectMake(10, 0, 10, 10);
        [self.imageView2.layer addSublayer:sublayer2];
    }
    if (parts.rezoTypeRect == kRezoTypeRect64) {
        CALayer *sublayer2 = [CALayer layer];
        sublayer2.backgroundColor = [NSColor yellowColor].CGColor;
        sublayer2.frame = CGRectMake(20, 0, 10, 10);
        [self.imageView2.layer addSublayer:sublayer2];
    }
    if (parts.watertype) {
        CALayer *sublayer2 = [CALayer layer];
        switch (parts.watertype){
            case kWaterTypeWater:
                sublayer2.backgroundColor = [NSColor cyanColor].CGColor;
                break;
            case kWaterTypePoison:
                sublayer2.backgroundColor = [NSColor purpleColor].CGColor;
                break;
            case kWaterTypeFlame:
                sublayer2.backgroundColor = [NSColor redColor].CGColor;
                break;
            case kWaterTypeHeal:
                sublayer2.backgroundColor = [NSColor greenColor].CGColor;
                break;
        }
        sublayer2.frame = CGRectMake(30, 0, 10, 10);
        [self.imageView2.layer addSublayer:sublayer2];
    }
}

- (void)runAnimation {
    MEGameParts *parts = [self.representedObject objectForKey:@"game_parts"];
    [self.imageView setWantsLayer:YES];

    /*
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetBlendMode(context, kCGBlendModeClear);
    */

    CALayer* animationLayer = [CALayer layer];
    //[animationLayer drawInContext:context];
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
    self.selected = YES;
    NSNotification *n =
            [NSNotification notificationWithName:@"selectedGameParts" object:self userInfo:item];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)setSelected:(BOOL)flag {
    [super setSelected:flag];
    NSLog(@"item selected");
}

@end


