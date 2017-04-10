//
//  WeatherViewController.m
//  WeatherApp
//
//  Created by Potter on 09/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WeatherViewController.h"

@interface WeatherViewController ()

//UI Components

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *weatherSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempratureLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempratureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dayIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nightIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dayWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *nightWeatherLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (retain, nonatomic) UIView *transperentloadingView;


//Data controller
@property (nonatomic,retain) WeatherDataController *dataCtrl;


@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) GMSPlacesClient *placesClient;


@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_dataCtrl)
    {
        _dataCtrl = [[WeatherDataController alloc] init];
    }
    
    [self setRandomBackgroundColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [self getWeatherDataForSelectedCity];
    
}

-(void)getWeatherDataForSelectedCity
{
    [self addLoadingView];
    
    [_dataCtrl getCurrentLocationWeatherWithSuccess:^{
        
        [self removeloadingView];
        
        [self setupView];
        
    } onFailure:^{
        
        [self removeloadingView];
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:ERROR message:SOMETHING_WENT_WRONG preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    UIColor *randomColor = [self setRandomBackgroundColor];
    
    _backgroundView.backgroundColor = randomColor;
    [_shareButton setTitleColor:randomColor forState:UIControlStateNormal];
    
    _weatherSummaryLabel.text = [NSString stringWithFormat:@"%@ in %@", _dataCtrl.weather.weatherSummary,[[NSUserDefaults standardUserDefaults] valueForKey:CITY_NAME]];
    
    _maxTempratureLabel.text = [NSString stringWithFormat:@"%.1f", _dataCtrl.weather.maxTemprature.floatValue];
    _minTempratureLabel.text = [NSString stringWithFormat:@"%.1f", _dataCtrl.weather.minTemprature.floatValue];
    
    _dayWeatherLabel.text = [NSString stringWithFormat:@"%@", _dataCtrl.weather.dayText];
    _nightWeatherLabel.text = [NSString stringWithFormat:@"%@",
                               _dataCtrl.weather.nightText];
    
    _dayIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_dataCtrl.weather.dayIcon.intValue]];
    _nightIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_dataCtrl.weather.nightIcon.intValue]];
}

-(UIColor *)setRandomBackgroundColor
{
    int min = 0;
    int max = 10;
    
    UIColor *randomColor;
    
    int randNum = min + arc4random_uniform(max - min + 1);
    
    switch (randNum)
    {
        case 0:
            randomColor = PINK_COLOR;
            break;
            
        case 1:
            randomColor = ORANGE_COLOR;
            break;
            
            
        case 2:
            randomColor = GREEN_COLOR;
            break;
            
        case 3:
            randomColor = BEIGE_COLOR;
            break;
            
        case 4:
            randomColor = LIGHT_GRAY_COLOR;
            break;
            
        case 5:
            randomColor = DARK_BLUE_COLOR;
            break;
            
        case 6:
            randomColor = LIGHT_BLUE_COLOR;
            break;
            
        case 7:
            randomColor = SKY_BLUE_COLOR;
            break;
            
        case 8:
            randomColor = DARK_GRAY_COLOR;
            break;
            
        case 9:
            randomColor = PURPLE_COLOR;
            break;
            
        case 10:
            randomColor = BROWN_COLOR;
            break;
            
        default: randomColor = DARK_BLUE_COLOR;
            break;
    }
    
    return randomColor;
    
}

#pragma mark - Location Methods

-(void)detectCurrentLocationSelected
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
            
            [[NSUserDefaults standardUserDefaults] setValue:place.name forKey:CITY_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_dataCtrl getLocationKeyWithSuccess:^{
                
                [self removeloadingView];
                [self getWeatherDataForSelectedCity];
                
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

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self addLoadingView];
    
    // Do something with the selected place.
    // NSLog(@"Place name %@", place.name);
    
    [[NSUserDefaults standardUserDefaults] setValue:place.name forKey:CITY_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_dataCtrl getLocationKeyWithSuccess:^{
        
        [self removeloadingView];
        
      [self getWeatherDataForSelectedCity];
        
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


-(void)searchCitySelected
{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    acController.autocompleteFilter.type = kGMSPlacesAutocompleteTypeFilterCity;
    [self presentViewController:acController animated:YES completion:nil];
}

#pragma mark - Loading View

-(void)addLoadingView{
    
    if(!_transperentloadingView){
        
        _transperentloadingView =[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        _transperentloadingView.backgroundColor=[self setRandomBackgroundColor];
        _transperentloadingView.alpha=1.0;
        _transperentloadingView.center = self.view.center;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [indicator startAnimating];
        [indicator setCenter:_transperentloadingView.center];
        [indicator setColor:[UIColor whiteColor]];
        [_transperentloadingView addSubview:indicator];
    }
    
    [self.view addSubview:_transperentloadingView];
}

-(void)removeloadingView{
    
    [_transperentloadingView removeFromSuperview];
}

#pragma mark - Button Actions

- (IBAction)shareButtonAction:(id)sender
{
    NSString *message = [NSString stringWithFormat:@"It is a %@ in %@ with maximum temprature %.1f°C and minimum temprature %.1f°C. Get latest weather updates via WeatherApp.", _dataCtrl.weather.weatherSummary, [[NSUserDefaults standardUserDefaults] valueForKey:CITY_NAME], _dataCtrl.weather.maxTemprature.floatValue,_dataCtrl.weather.minTemprature.floatValue];
    
    NSArray *activityItems = @[message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}


- (IBAction)locationButtonAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Hi %@",[[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME]] message:@"Would you like to change your city?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    actionSheet.view.tintColor = DARK_GRAY_COLOR;
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Detect current location." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self detectCurrentLocationSelected];
      
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Search City." style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self searchCitySelected];
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)historyButtonAction:(id)sender
{
    
}

@end
