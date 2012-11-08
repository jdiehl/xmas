//
//  ViewController.m
//  Xmas
//
//  Created by Jonathan Diehl on 05.11.12.
//  Copyright (c) 2012 Jonathan Diehl. All rights reserved.
//

#import "XmasController.h"

#import "Snowflake.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )


@implementation XmasController


#pragma mark - Private Methods

- (void)addSnowflake;
{
	// create a new snow flake
	Snowflake *snowflake = [Snowflake new];
	[self.snowflakes addObject:snowflake];
	snowflake.completionBlock = ^(Snowflake *snowflake) {
		[snowflake remove];
		[self.snowflakes removeObject:snowflake];
	};
	
	// randomize the star's configuration
	[snowflake randomize];
	
	// add the star to the view
	[snowflake addToView:self.view];
	
	// animate the star
	[snowflake animate];
	
	// schedule adding more stars
	NSTimeInterval timeUntilNextStar = (random() % 10) / 20.;
	if (IS_IPAD) {
		timeUntilNextStar /= 4.;
	}
	_timer = [NSTimer scheduledTimerWithTimeInterval:timeUntilNextStar target:self selector:@selector(addSnowflake) userInfo:nil repeats:NO];
}


#pragma mark - UIViewController

// load the view
- (void)loadView;
{
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	
	// set up the background image
	UIImage *image;
	if (IS_IPHONE_5) {
		image = [UIImage imageNamed:@"Default-568h"];
	} else if (IS_IPAD) {
		image = [UIImage imageNamed:@"Default-Portrait"];
	} else {
		image = [UIImage imageNamed:@"Default"];
	}
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	[self.view addSubview:imageView];
}

// view did load
- (void)viewDidLoad;
{
    [super viewDidLoad];
	
	// initialize the snow flakes array
	_snowflakes = [NSMutableArray new];
	
	// add the first snow flake
	[self addSnowflake];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)dealloc
{
    [self.timer invalidate];
}

@end
