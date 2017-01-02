//
//  ViewController.m
//  MyProject
//
//  Created by sathya on 27/12/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Dashboard.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (IBAction)submit:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    NSString *userName=_loginId.text;
    NSString *userPassword=_password.text;
       if(userName.length>0){
         if(userPassword.length>0){
             if (networkStatus == NotReachable)
             {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"check your Internet" preferredStyle:UIAlertControllerStyleAlert];
                 
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popViewControllerAnimated:YES];
        }];
                 [alert addAction:yesButton];
                                          
                         [self presentViewController:alert animated:YES completion:nil];
             }else{
             NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
             [parameters setObject:userName forKey:@"username"];
             [parameters setObject:userPassword forKey:@"password"];
             
             AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
             manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
             
             [manager POST:@"http://demo.futuristicschools.com/WS/Services/Login.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSString *str =[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"success"]];
                 if([str isEqualToString:@"1"]){
                     NSArray *param =[responseObject valueForKey:@"parameters"];
                     NSString *apiKeyStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"apiKey"]];
                     if (apiKeyStr.length !=0)
                     {
                         //save data in preference
                         NSString *imagePathStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"imagePath"]];
                         NSString *loginIdStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"loginId"]];
                         NSString *nameStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"name"]];
                         NSString *userDetailsIdStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"userDetailsId"]];
                         NSString *userTypeIdStr =[NSString stringWithFormat:@"%@",[param[0] valueForKey:@"userTypeId"]];                         NSUserDefaults *store=[NSUserDefaults standardUserDefaults];
                         [store setObject:apiKeyStr forKey:@"API_KEY"];
                         [store setObject:imagePathStr forKey:@"IMAGE_PATH"];
                         [store setObject:loginIdStr forKey:@"LOGIN_ID"];
                         [store setObject:nameStr forKey:@"NAME"];
                         [store setObject:userDetailsIdStr forKey:@"USER_DETAILS"];
                         [store setObject:userTypeIdStr forKey:@"USER_TYPE"];
        UINavigationController *navController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"   bundle:nil];                         
        Dashboard *dashboard = [storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];

        [navController pushViewController:dashboard animated:YES];
                     }
                 
                 } else {
                     UIAlertController * alert = [UIAlertController
                                                  alertControllerWithTitle:@"Validation Error"
                                                  message:[responseObject valueForKey:@"message"]
                                                  preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* yesButton = [UIAlertAction
                                                 actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 }];
                     
                     
                     [alert addAction:yesButton];
                     
                     [self presentViewController:alert animated:YES completion:nil];

                 }
                 NSLog(@"success!");
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"error: %@", error);
             }];
             }
         }else {
             UIAlertController * alert = [UIAlertController
                                          alertControllerWithTitle:@"Validation Error"
                                          message:@"Enter valid password"
                                          preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"Ok"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
             
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }

    }else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Validation Error"
                                     message:@"Enter valid LoginID"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    
}
- (IBAction)reset:(id)sender {
    //Refresh the view
    self.loginId.text =@"";
    self.password.text =@"";
}
@end
