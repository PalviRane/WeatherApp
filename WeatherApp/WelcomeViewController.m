//
//  WelcomeViewController.m
//  WeatherApp
//
//  Created by Potter on 08/04/17.
//  Copyright © 2017 PalviRane. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HeaderConstants.h"

#import "WeatherViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) GMSPlacesClient *placesClient;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//GOOLGE PLACES DELEGATES
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    [[NSUserDefaults standardUserDefaults] setValue:place.name forKey:CITY_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WeatherViewController *weatherViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherViewController"];
    
    [self.navigationController pushViewController:weatherViewController
                                         animated:YES];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Button Action

- (IBAction)detectCurrentLocationAction:(id)sender
{
   [self.locationManager requestAlwaysAuthorization];
    
    
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
            
            WeatherViewController *weatherViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherViewController"];
            
            [self.navigationController pushViewController:weatherViewController
                                                 animated:YES];
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
