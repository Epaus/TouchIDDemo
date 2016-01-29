//
//  ViewController.m
//  TouchIDDemo
//
//  Created by Estelle Paus on 1/29/16.
//  Copyright © 2016 Estelle Paus. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) KeychainWrapper * keychainWrapper;
@property (nonatomic,assign) int createButtonTag;
@property (nonatomic,assign) int loginButtonTag;
@property (nonatomic, strong) LAContext * localAuthContext;
@property (nonatomic) UIButton * loginCreateButton;
@property (nonatomic) UILabel * createInfoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect fullScreenRect = [[UIScreen mainScreen] bounds];
    float width = fullScreenRect.size.width;
    float height = fullScreenRect.size.height;
    
    _loginCreateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      _loginCreateButton.frame = CGRectMake(width * 0.45, height * 0.60, 100.0, 30.0);
    _loginCreateButton.hidden = NO;
    UIImage * buttonImage = [UIImage imageNamed:@"Button.png"];
    [_loginCreateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_loginCreateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    
    _createInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.45,height * 0.50,100.0,24.0)];
    _createInfoLabel.text = @"Create User";
    _loginButtonTag = 1;
    _createButtonTag = 0;
   
    BOOL hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"];
    
    if (/*hasLogin*/true) {
        NSLog(@"login user");
        [_loginCreateButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginCreateButton.tag = _loginButtonTag;
        _createInfoLabel.hidden = YES;
    } else {
        NSLog(@"create user");
        [_loginCreateButton setTitle:@"Create" forState:UIControlStateNormal];
        _loginCreateButton.tag = _createButtonTag;
        _createInfoLabel.hidden = NO;
    }
    [self.view addSubview:_loginCreateButton];
    [self.view addSubview:_createInfoLabel];
    
    
    NSString * storeUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    
    NSError *error = nil;
    if ([_localAuthContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"can use touchID");
    }




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
