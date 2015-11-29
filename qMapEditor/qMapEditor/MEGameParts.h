//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MECategory : NSObject <NSCoding> {
}
@property NSString *categoryName;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;

+ (NSArray *)existCategories;
@end

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

typedef enum PavementType {
    kPavementTypeNone = 0,
    kPavementTypeLv1 = 1,
    kPavementTypeLv2,
    kPavementTypeLv3,
    kPavementTypeLv4,
    kPavementTypeLv5,
} PavementType;

typedef enum MacroType {
    kMacroTypeRoad = 1,
    kMacroTypeRough,
    kMacroTypeWall,
    kMacroTypeCantEnter,
    kMacroTypeOther,
} MacroType;

@interface MEGameParts : NSObject <NSCopying, NSCoding>

@property NSMutableArray *tiles;
@property NSMutableArray *categories;
@property BOOL walkable;
@property WaterType watertype;
@property CGFloat durationPerFrame;
@property NSDictionary *customEvents;
@property NSImageView *sampleImage;
@property NSString *name;
@property BOOL half;
@property BOOL snow;
@property RezoTypeRect rezoTypeRect;
@property PavementType pavementType;
@property NSMutableArray<NSNumber *> *macroTypes;
@property NSString *harfIdName;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithTiles:(NSArray *)tiles
           walkable:(BOOL)walkable
          waterType:(WaterType)waterType
           duration:(CGFloat)duration
               half:(BOOL)half
           rezoType:(RezoTypeRect)rezoType
         categories:(NSArray *)categories
       pavementType:(PavementType)pavementType
         macroTypes:(NSMutableArray *)macroTypes
               snow:(BOOL)snow
         harfIdName:(NSString*)harfIdName
       customEvents:(NSDictionary *)custom;

- (NSImage *)image;

- (void)initSampleImageWithKVO:(BOOL)notify;

- (void)refOf:(MEGameParts *)otherObj;
- (int)getCategoryInt;

@end