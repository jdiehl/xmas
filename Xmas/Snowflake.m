//
//  Snowflake.m
//  Xmas
//

#import "Snowflake.h"

// helpler function to compute a point on an arc at the given angle
CGPoint CGPointMakeFromArc(CGPoint center, CGFloat radius, CGFloat angle);


@implementation Snowflake

- (void)randomize;
{
	self.size = 10 + random() % 20;
	self.beginPosX = (CGFloat)random() / NSIntegerMax;
	self.beginRotation = (random() % 360) / 180. * M_PI;
	self.opacity = .5 + (random() % 25 / 100.);
	self.numSpikes = self.size / 5 + 3;
	self.numCrests = self.size / 10;
	self.color = [UIColor whiteColor];
	self.animationDuration = 10. + (random() % 50) / 10.;
	self.endPosX = self.beginPosX + (CGFloat)random() / NSIntegerMax * .2;
	self.endRotation = self.beginRotation + (random() % 7 - 4) * M_PI;
}

- (void)addToView:(UIView *)view;
{
	NSAssert(self.layer == nil, @"Star cannot be added to multiple views");
	
	// create and display the star layer
	_layer = [CALayer new];
	self.layer.delegate = self;

	// configure the layer
	self.layer.frame = CGRectMake(self.beginPosX * (view.bounds.size.width - self.size), -(CGFloat)self.size, (CGFloat)self.size, (CGFloat)self.size);
	self.layer.opacity = self.opacity;

	// display the layer
	[self.layer setNeedsDisplay];
	[view.layer addSublayer:self.layer];
}

- (void)animate;
{
	NSAssert(self.layer != nil, @"Star must be added to a view before it can be animated");
	
	CALayer *superlayer = self.layer.superlayer;
	
	// create a move animation
	CGPoint to = CGPointMake(self.endPosX * (superlayer.bounds.size.width - self.size), superlayer.bounds.size.height + 1.);
	CABasicAnimation *animMove = [CABasicAnimation new];
	animMove.delegate = self;
	animMove.keyPath = @"position";
	animMove.toValue = [NSValue valueWithCGPoint:to];
	animMove.duration = self.animationDuration;
	animMove.removedOnCompletion = NO;
	[self.layer addAnimation:animMove forKey:@"move"];
	
	// create rotate animation
	CABasicAnimation *animRotate = [[CABasicAnimation alloc] init];
	animRotate.keyPath = @"transform.rotation";
	animRotate.fromValue = [NSNumber numberWithFloat:self.beginRotation];
	animRotate.toValue = [NSNumber numberWithFloat:self.endRotation];
	animRotate.duration = self.animationDuration;
	[self.layer addAnimation:animRotate forKey:@"rotate"];
}

- (void)remove;
{
	NSAssert(self.layer != nil, @"Cannot remove star that was never created");
	
	[self.layer removeFromSuperlayer];
	_layer = nil;
}

- (void)dealloc
{
	if (self.layer) {
		[self remove];
	}
}


#pragma mark - CAAnimationDelegate

// animation ended
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
{
	if (flag && self.completionBlock) {
		self.completionBlock(self);
	}
}


#pragma mark - CALayerDelegate

// draw the start layer
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)c;
{
	// draw the spikes
	[self drawSpikesForLayer:layer inContext:c];
	
	// draw the crests
	[self drawCrestsForLayer:layer inContext:c];
}


# pragma mark - Private Methods

// draw the spikes of the snowflake
- (void)drawSpikesForLayer:(CALayer *)layer inContext:(CGContextRef)c;
{
	CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
	
	// configure stroke
	CGContextSetLineWidth(c, 1.0);
	CGContextSetStrokeColorWithColor(c, self.color.CGColor);
	
	// init lines array
	CGPoint points[self.numSpikes * 2];
	
	// create lines
	CGFloat a = 0.0;
	CGFloat r = MIN(center.x, center.y);
	for (NSInteger i = 0; i < self.numSpikes; i++) {
		a = i * M_PI * 2.0 / self.numSpikes;
		points[i * 2] = center;
		points[i * 2 + 1] = CGPointMakeFromArc(center, r, a);
	}
	
	// draw
	CGContextAddLines(c, points, self.numSpikes * 2);
	CGContextDrawPath(c, kCGPathStroke);
}

// draw the crests of the flake
- (void)drawCrestsForLayer:(CALayer *)layer inContext:(CGContextRef)c;
{
	CGPoint center = CGPointMake(CGRectGetMidX(layer.bounds), CGRectGetMidY(layer.bounds));
	CGFloat r_max = MIN(center.x, center.y);
	
	// configure stroke
	CGContextSetLineWidth(c, 1.0);
	CGContextSetStrokeColorWithColor(c, self.color.CGColor);
	
	NSInteger i, j;
	CGFloat a, a_delta, r, r_delta;
	CGPoint points[3];
	
	r_delta = r_max * 0.7 / (self.numCrests + 1);
	for (j = 0; j < self.numCrests; j++) {
		
		r = r_max * ((CGFloat) (j+1) / (self.numCrests + 1));
		if(random() % 1 == 1) r_delta = -r_delta;
		
		a_delta = M_PI * 2.0 / self.numSpikes * 0.25 + (random() % 25) / 100.0;
		
		// draw the jth crest
		for(i = 0; i < self.numSpikes; i++) {
			
			// draw the ith spike
			a = i * M_PI * 2.0 / self.numSpikes;
			points[0] = CGPointMakeFromArc(center, r+r_delta, a-a_delta);
			points[1] = CGPointMakeFromArc(center, r, a);
			points[2] = CGPointMakeFromArc(center, r+r_delta, a+a_delta);
			
			// draw
			CGContextAddLines(c, points, 3);
			CGContextDrawPath(c, kCGPathStroke);
		}
		
	}
	
}

@end


CGPoint CGPointMakeFromArc(CGPoint center, CGFloat radius, CGFloat angle) {
	return CGPointMake(center.x - radius * cos(angle), center.y - radius * sin(angle));
}
