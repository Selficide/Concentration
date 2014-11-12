//
//  Timer.h
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/11/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TimerCompleted)();

@interface Timer : UIView
@property (copy) TimerCompleted timerCompletedBlock;

- (void)start;
- (void)setMaxSeconds:(unsigned int)maxSeconds;
@end
