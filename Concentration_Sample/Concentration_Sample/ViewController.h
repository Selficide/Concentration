//
//  ViewController.h
//  Concentration_Sample
//
//  Created by Shad Ratliff on 11/11/14.
//  Copyright (c) 2014 Shad Ratliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"

@interface ViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;

@end

