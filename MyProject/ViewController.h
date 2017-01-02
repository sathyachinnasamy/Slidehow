//
//  ViewController.h
//  MyProject
//
//  Created by sathya on 27/12/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *loginId;
@property (strong, nonatomic) IBOutlet UITextField *password;

- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *reset;

- (IBAction)reset:(id)sender;

@end

