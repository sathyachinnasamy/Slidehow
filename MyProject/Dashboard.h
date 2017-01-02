//
//  Dashboard.h
//  MyProject
//
//  Created by sathya on 28/12/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dashboard : UIViewController{
    NSMutableArray *titleNameArr;
    NSMutableArray *titleImageArr;
    NSMutableArray *colorArr;
        
    IBOutlet UICollectionView *imageData;
   
}

@end
