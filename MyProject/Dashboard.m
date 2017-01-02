//
//  Dashboard.m
//  MyProject
//
//  Created by sathya on 28/12/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "Dashboard.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "ImageCollectionCell.h"
@interface Dashboard ()<UIScrollViewDelegate>
{
    NSArray* bannerContentsArr;
}
@end

@implementation Dashboard

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bannerContentsArr =[[NSArray alloc]init];
    [self getImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getImages {
    //check internet availability
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
           }
    else
    {
        NSString *urlString=[NSString stringWithFormat:@"http://demo.futuristicschools.com/WS/Services/getBannersList.php"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
         {
             NSError *error = nil;
             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
             NSArray *imageArray=[JSON valueForKey:@"parameters"];

      NSSortDescriptor*brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"banner_title" ascending:YES];
            NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
            bannerContentsArr = [imageArray sortedArrayUsingDescriptors:sortDescriptors];
             
            // creating scroll view programmatically
             
             UIScrollView *scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200)];
             scr.tag = 1;
             scr.autoresizingMask=UIViewAutoresizingNone;
             scr.scrollEnabled = FALSE;
             [self.view addSubview:scr];
             //load banner data to scrollview
             for (int i=0; i<[bannerContentsArr count]; i++)
             {
                 
                 NSArray *currentBannerArr =[bannerContentsArr objectAtIndex:i];
                 UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i*scr.frame.size.width, 0, scr.frame.size.width, scr.frame.size.height)];
                 NSString *mainUrl=[NSString stringWithFormat:@"%@",[currentBannerArr valueForKey:@"banner_image"]];
                 [imgV sd_setImageWithURL:[NSURL URLWithString:mainUrl]
                         placeholderImage:[UIImage imageNamed:@"default-placeholder.png"]];
                 imgV.contentMode=UIViewContentModeScaleToFill;
                 [scr addSubview:imgV];
                 
                 UIView *blurrVw =[[UIImageView alloc] initWithFrame:CGRectMake(i*scr.frame.size.width+10, 170, scr.frame.size.width-20, 30)];
                 blurrVw.backgroundColor =[UIColor blackColor];
                 blurrVw.alpha = 0.5f;
                 [scr addSubview:blurrVw];
                 
                 UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(i*scr.frame.size.width+10, 170, scr.frame.size.width-20, 30)];
                 titleLabel.textColor =[UIColor whiteColor];
                 titleLabel.textAlignment = NSTextAlignmentCenter;
                 titleLabel.text =[NSString stringWithFormat:@"%@",[currentBannerArr valueForKey:@"banner_title"]];
                 [scr addSubview:titleLabel];
             }
             
             [scr setContentSize:CGSizeMake(scr.frame.size.width*[bannerContentsArr count], scr.frame.size.height)];
             [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
             
    // set data in array for collection view
             
             titleNameArr =[[NSMutableArray alloc] initWithObjects:@"Attendance",@"Assesment", @"Knowledge Bank", @"Notice Board" , @"Home Work", @"Fees Detail" ,@"News",@"Calendar", @"Holiday List", @"Progress Report",@"Track My bus", @"Competitions", @"Inbox ", @"Settings", @"Project Work" , @"Video Gallery" , @"Facebook" , @"Contact Us", nil];
             colorArr =[[NSMutableArray alloc] initWithObjects:@"411f8f",@"74007d", @"72378b", @"d1760b" , @"22512f", @"8f0830" ,@"b85917",@"131313", @"436fa0", @"44a64f",@"007aff", @"984fc4", @"16a086 ", @"d25400", @"bd6438" , @"fad52f" , @"2C428D" , @"ec3024", nil];
             titleImageArr =[[NSMutableArray alloc] initWithObjects:@"attendance.png",@"assesement.png", @"knowledge.png", @"notice.png" , @"homework.png", @"fees.png" ,@"news.png",@"calendar.png", @"holiday.png", @"report.png",@"bus.png", @"competitions.png", @"inbox.png", @"settings.png", @"project.png" , @"video.png" , @"fb.png" , @"customer-care.png", nil];
        
             [imageData reloadData];

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             NSLog(@"Error: %@", error.localizedDescription);
         }];
    }

}
#pragma mark SLIDESHOW
- (void)scrollingTimer
{
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    CGFloat contentOffset = scrMain.contentOffset.x;
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    
    if( nextPage!=[bannerContentsArr count] )
    {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
    }
    else
    {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
    }
}

#pragma mark COLLECTION VIEW

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}
//set number of sections to be created in collection view
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [titleNameArr count];
}
//populate collection view data
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellName=@"ImageCell";
    ImageCollectionCell *cell=(ImageCollectionCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    cell.cellLabel.text = [NSString stringWithFormat:@"%@",[titleNameArr objectAtIndex:indexPath.row]];
    
    cell.backgroundColor = [self colorWithHexString:[NSString stringWithFormat:@"%@",[colorArr objectAtIndex:indexPath.row]]];
    cell.cellImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",[titleImageArr objectAtIndex:indexPath.row]]];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Name of the selected Image"message:[titleNameArr objectAtIndex:indexPath.row]
        preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
     style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark COLOR CODE

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
- (IBAction)logout:(id)sender {
    //deleting values in preference
    
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    
    NSDictionary *userDefaultsDictionary = [userDefaults dictionaryRepresentation];
    
    for (NSString *key in userDefaultsDictionary) {
        
            [userDefaults removeObjectForKey:key];
    }
    //moving to login viewcontroller
    [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]] animated:YES];
    

    
}


@end
