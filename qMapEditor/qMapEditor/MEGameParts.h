//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface METile : NSObject <NSCopying, NSCoding> {
}
@property NSURL *tileFilePath;
@property CGRect tileRect;

- (id)initWithURL:(NSURL *)filePath rect:(CGRect)rect;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;

- (NSImage *)image;
@end

typedef enum WaterType {
    kWaterTypeNone = 0, //個体、ソリッド
    kWaterTypeWater = 1,
    kWaterTypePoison,
    kWaterTypeFlame,
    kWaterTypeHeal,
} WaterType;

typedef enum RezoTypeRect {
    kRezoTypeRect32 = 0, //旧バージョン
    kRezoTypeRect64 = 1,
} RezoTypeRect;

@interface MEGameParts : NSObject <NSCopying, NSCoding> {
}
@property NSMutableArray *tiles;
@property BOOL walkable;
@property WaterType watertype;
@property CGFloat durationPerFrame;
@property NSDictionary *customEvents;
@property NSImageView *sampleImage;
@property NSString *name;

@property BOOL half;
@property RezoTypeRect rezoTypeRect;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithTiles:(NSArray *)tiles
           walkable:(BOOL)walkable
          waterType:(WaterType)waterType
           duration:(CGFloat)duration
               half:(BOOL)half
           rezoType:(RezoTypeRect)rezoType
       customEvents:(NSDictionary *)custom;

- (NSImage *)image;

- (void)initSampleImageWithKVO:(BOOL)notify;

- (void)refOf:(MEGameParts *)otherObj;

@end