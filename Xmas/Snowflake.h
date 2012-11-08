//
//  Snowflake.h
//  Xmas
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Snowflake : NSObject

@property (readonly) CALayer *layer;

// The star configuration
@property (assign) NSUInteger size;
@property (assign) CGFloat beginPosX;
@property (assign) CGFloat beginRotation;
@property (assign) CGFloat opacity;
@property (assign) NSUInteger numSpikes;
@property (assign) NSUInteger numCrests;
@property (strong) UIColor *color;
@property (assign) NSTimeInterval animationDuration;
@property (assign) CGFloat endPosX;
@property (assign) CGFloat endRotation;

@property (strong) void (^completionBlock)(Snowflake *);

- (void)randomize;
- (void)addToView:(UIView *)view;
- (void)animate;
- (void)remove;

@end
