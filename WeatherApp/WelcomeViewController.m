//
//  WelcomeViewController.m
//  WeatherApp
//
//  Created by Potter on 08/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HeaderConstants.h"
#import "WrapperManager.h"

#import "WeatherViewController.h"
#import "WelcomeDataController.h"

@interface WelcomeViewController ()

//UI Elements

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (retain, nonatomic) UIView *transperentloadingView;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) GMSPlacesClient *placesClient;

@property (nonatomic,retain) WelcomeDataController *dataCtrl;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_dataCtrl)
    {
        _dataCtrl = [[WelcomeDataController alloc] init];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Setup View

-(void)setupView
{
     [self.view layoutIfNeeded];
    
    _userImageView.layer.cornerRadius = _userImageView.frame.size.height/2;
    _userImageView.clipsToBounds = YES;
    
    _userImageView.image = [[WrapperManager sharedInstance].weatherWrapper getUserImage];
    
    _userNameLabel.text = [NSString stringWithFormat:@"Hi %@.", [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME]];
}


#pragma mark - GOOLGE PLACES DELEGATES
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    [self addLoadingView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Do something with the selected place.
   // NSLog(@"Place name %@", place.name);
    
    //Save City Name in USerDefaults
    [[NSUserDefaults standardUserDefaults] setValue:place.name forKey:CITY_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Add CityName in History
    [_dataCtrl createCityArrayToSavHistoryWithCityName:place.name];

    [_dataCtrl getLocationKeyWithSuccess:^{
        
        [self removeloadingView];
        
        WeatherViewController *weatherViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherViewController"];
        
        [self.navigationController pushViewController:weatherViewController
                                             animated:YES];
        
    } onFailure:^{
        [self removeloadingView];
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:ERROR message:SOMETHING_WENT_WRONG preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
    
   
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
  //  NSLog(@"Error: %@", [error description]);
    
    [self removeloadingView];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:ERROR message:SOMETHING_WENT_WRONG preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Loading View

-(void)addLoadingView{
    
    if(!_transperentloadingView){
        
        _transperentloadingView =[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        _transperentloadingView.backgroundColor=[UIColor grayColor];
        _transperentloadingView.alpha=0.5;
        _transperentloadingView.center = self.view.center;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [indicator startAnimating];
        [indicator setCenter:_transperentloadingView.center];
        [indicator setColor:[UIColor blackColor]];
        [_transperentloadingView addSubview:indicator];
    }
    
    [self.view addSubview:_transperentloadingView];
}

-(void)removeloadingView{
    
    [_transperentloadingView removeFromSuperview];
}


#pragma mark - Button Action

- (IBAction)detectCurrentLocationAction:(id)sender
{
   [self.locationManager requestAlwaysAuthorization];
    
    [self addLoadingView];
    
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
           // NSLog(@"Current Place error %@", [error localizedDescription]);
            
            [self removeloadingView];
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:ERROR message:SOMETHING_WENT_WRONG preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            //NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            
            //Save City Name in USerDefaults
            [[NSUserDefaults standardUserDefaults] setValue:place.name forKey:CITY_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //Add CityName in History
            [_dataCtrl createCityArrayToSavHistoryWithCityName:place.name];
            
            [_dataCtrl getLocationKeyWithSuccess:^{
                
                [self removeloadingView];
                
                WeatherViewController *weatherViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherViewController"];
                
                [self.navigationController pushViewController:weatherViewController
                                                     animated:YES];
                
            } onFailure:^{
                
                 [self removeloadingView];
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:ERROR message:SOMETHING_WENT_WRONG preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
        }
        
    }];
}

- (IBAction)selectCityAction:(id)sender
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.autocompleteFilter.type = kGMSPlacesAutocompleteTypeFilterCity;
    [self presentViewController:acController animated:YES completion:nil];
}

@end
