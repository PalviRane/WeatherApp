//
//  SignInViewController.m
//  WeatherApp
//
//  Created by Potter on 07/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInCollectionViewCell.h"

#define COLLECTION_VIEW_CELL_IDENTIFIER @"SignInCellIdentifier"

@interface SignInViewController ()

{
    NSTimer *scrollingTimer;
    NSIndexPath *currentIndexPath;
}

//UI Elements

@property (weak, nonatomic) IBOutlet UICollectionView *signInCollectionView;

//DataController

@property (nonatomic,retain) SignInDataController *dataCtrl;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (!_dataCtrl)
    {
        _dataCtrl = [[SignInDataController alloc] init];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startTimerAction];
}

- (void)onTimer {
    
    float contentOffsetWhenFullyScrolledRight = self.signInCollectionView.frame.size.width * ([self.dataCtrl.weatherArray count]-1);
    
    NSLog(@"TIME %ld, %ld, %f",(long)currentIndexPath.row,(long)currentIndexPath.section,self.signInCollectionView.contentOffset.x);
    
    if (self.signInCollectionView.contentOffset.x == contentOffsetWhenFullyScrolledRight)
    {
        currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.signInCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        
        [scrollingTimer invalidate];
        
        [self startTimerAction];
    }
   else
    {
        [self.signInCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}

-(void)startTimerAction
{
    [_signInCollectionView reloadData];
    
    scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataCtrl.weatherArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    
    NSLog(@"CELL %ld, %ld, %f",(long)currentIndexPath.row,(long)currentIndexPath.section,self.signInCollectionView.contentOffset.x);
    
    SignInCollectionViewCell *collCell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_CELL_IDENTIFIER forIndexPath:indexPath];
    
    collCell.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]); //remove cell Border
    
    collCell.weatherImageView.image = [UIImage imageNamed: [_dataCtrl.weatherArray objectAtIndex:indexPath.row]];
    
    return collCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.signInCollectionView.frame.size.width, self.signInCollectionView.frame.size.height);
}


#pragma mark - Facebook

- (IBAction)facebookLoginPressed:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions: @[@"email", @"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error)
                                {
                                    NSLog(@"Process error");

                                }
                                else if (result.isCancelled)
                                {
                                    NSLog(@"Cancelled");

                                } else
                                {
                                    NSLog(@"Logged in");
                                    
                                    if ([FBSDKAccessToken currentAccessToken])
                                    {
                                        
                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, birthday, email, gender, picture.width(250).height(250)"}]
                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             if (!error)
                                             {
                                                 
                                                 NSLog(@"fetched user:%@", result);
                                                
                                             }
                                             else
                                             {
                                                 NSLog(@"fb Failure");
                                                 
                                                 
                                             }
                                         }];
                                        
                                    }
                                    
                                }
                            }];

}


@end
