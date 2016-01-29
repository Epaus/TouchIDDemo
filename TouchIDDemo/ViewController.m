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
@property (nonatomic) UITextField * usernameTextField;
@property (nonatomic) UITextField * passwordTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupUI];
    
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

    
    
    NSString * storeUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    
    NSError *error = nil;
    if ([_localAuthContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"can use touchID");
    }




}
- (void)setupUI {
    CGRect fullScreenRect = [[UIScreen mainScreen] bounds];
    float width = fullScreenRect.size.width;
    float height = fullScreenRect.size.height;
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake((width*0.5)-100,height*.20,200, 40)];
    _usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.placeholder = @"name";
    _usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _usernameTextField.keyboardType = UIKeyboardTypeDefault;
    _usernameTextField.returnKeyType = UIReturnKeyDone;
    _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.delegate = self;
    [self.view addSubview:_usernameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake((width*0.5)-100,height*.30,200, 40)];
    _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.placeholder = @"password";
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    
    
    _loginCreateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginCreateButton.frame = CGRectMake(width * 0.45, height * 0.60, 100.0, 30.0);
    _loginCreateButton.hidden = NO;
    UIImage * buttonImage = [UIImage imageNamed:@"Button.png"];
    [_loginCreateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_loginCreateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    
    _createInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.45,height * 0.50,100.0,24.0)];
    _createInfoLabel.text = @"Create User";
    [self.view addSubview:_loginCreateButton];
    [self.view addSubview:_createInfoLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
