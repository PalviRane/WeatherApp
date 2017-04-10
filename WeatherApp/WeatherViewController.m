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
    
    [self addLoadingView];
    
    [_dataCtrl getLocationKeyWithSuccess:^{
        
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


@end
