//
//  Timer.m
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/11/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import "Timer.h"
#import "KAProgressLabel.h"

@interface Timer ()
@property (nonatomic, strong) KAProgressLabel *progressLabel;
@property (nonatomic, strong) NSTimer* timer;
@property unsigned int secondsPassed;
@property (nonatomic)  unsigned int maxSeconds;
@end

@implementation Timer

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}

- (void)setMaxSeconds:(unsigned int)maxSeconds {
    _maxSeconds = (maxSeconds < 1) ? 1 : maxSeconds;
}

#pragma mark Timer methods

- (void) start {
    //Timer setup
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

#pragma mark Helper methods

/**
 * Helper method for setting up the basics
 */
- (void)setup {
    
    //Set default to sixty seconds
    self.maxSeconds = 60;
    self.secondsPassed = 0;
    
    //Progress Label setup
    self.progressLabel = [[KAProgressLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self.progressLabel setColorTable: @{
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelFillColor):[UIColor clearColor],
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):[UIColor clearColor],
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):[UIColor greenColor]
                                         }];
    [self.progressLabel setProgress:1.0f];
    [self.progressLabel setTextAlignment:NSTextAlignmentCenter];
    [self.progressLabel setText:[NSString stringWithFormat:@"%u",self.maxSeconds]];
    [self addSubview:self.progressLabel];
}

- (void)timerTick {
    self.secondsPassed++;
    unsigned int secondsRemaining = self.maxSeconds - self.secondsPassed;
    float progress = (float)secondsRemaining / (float)self.maxSeconds;
    [self.progressLabel setProgress:progress];
    [self.progressLabel setText:[NSString stringWithFormat:@"%u", secondsRemaining]];
    if(self.secondsPassed >= self.maxSeconds) {
        [self.timer invalidate];
        if(self.timerCompletedBlock != nil) {
            self.timerCompletedBlock();
        }
    }
    
}

@end
