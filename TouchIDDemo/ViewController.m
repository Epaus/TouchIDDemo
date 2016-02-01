//
//  ViewController.m
//  TouchIDDemo
//
//  Created by Estelle Paus on 1/29/16.
//  Copyright © 2016 Estelle Paus. All rights reserved.
//
// Notes:
// The first time you run this app, it will present you with a create user screen. Enter your username and password of choice, then touch the "Create"
// button.
// After a user is created, you will be presented with a login button.  For this app, there is only 1 user. After the user is created, you will not
// see the create button again unless you delete the app and load it again from xcode.
// When you run the app, already having an existing user, it starts immediately at the login screen. If the device is able to use touchID, it will
// immediatey provide the touchID login alert. To use touchID, touch your finger to the home button.  otherwise, press cancel and it will return you
// to the login screen.
// Once you have logged in via password or touch, you will be taken to the ParadiseViewController.  If you press exit, you will return to the login/
// touchId VC.
//
// Lesson learned: There is no authentication using the touchID other than the very secure touchID authentication which answers one question: Is the
// fingerprint stored on this device.  If it is, then you are authenticated.


#import "ViewController.h"



@interface ViewController ()
@property (strong, nonatomic) FXKeychain * keychainWrapper;
@property (nonatomic,assign) int createButtonTag;
@property (nonatomic,assign) int loginButtonTag;
@property (nonatomic, strong) LAContext * localAuthContext;
@property (nonatomic) UIButton * loginCreateButton;
@property (nonatomic) UIButton * continueToLoginButton;
@property (nonatomic) UILabel * createInfoLabel;
@property (nonatomic) UITextField * usernameTextField;
@property (nonatomic) UITextField * passwordTextField;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * password;


@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {

     NSError *error = nil;
    _loginButtonTag = 1;
    _createButtonTag = 0;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"])
    {
        [self hasLogin:YES];
        _localAuthContext = [[LAContext alloc] init];
        
        if ([_localAuthContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            NSLog(@"can use touchID");
            [self loginWithTouchId];
        } else {
            NSLog(@"cannot use touchID");
        }
    }  else {
        [self hasLogin:NO];
    }
    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
     _keychainWrapper = [FXKeychain defaultKeychain];

    [self setupUI];
    
//    _loginButtonTag = 1;
//    _createButtonTag = 0;
    
    

}

-(void)hasLogin:(BOOL)hasLogin {
    if (hasLogin) {
        NSLog(@"login user");
        [_loginCreateButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginCreateButton.tag = _loginButtonTag;
        _createInfoLabel.hidden = YES;
        [_loginCreateButton addTarget:self
                               action:@selector(login)
                     forControlEvents:UIControlEventTouchUpInside];
    } else {
        NSLog(@"create user");
        [_loginCreateButton setTitle:@"Create" forState:UIControlStateNormal];
        _loginCreateButton.tag = _createButtonTag;
        _createInfoLabel.hidden = NO;
        [_loginCreateButton addTarget:self
                               action:@selector(createUser)
                     forControlEvents:UIControlEventTouchUpInside];
    }

}


- (void)createUser {

    NSLog(@"createUser");

    if ((![_usernameTextField.text isEqualToString:@""]) || (![_passwordTextField.text isEqualToString:@""])) {
        BOOL hasLoginKey = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"];
        if (!hasLoginKey) {
            [[NSUserDefaults standardUserDefaults] setValue:self.usernameTextField.text forKey:@"username"];
        }
        //NSString * serviceName = [NSBundle mainBundle].bundleIdentifier;
       
        [_keychainWrapper setObject:_passwordTextField.text forKey:@"password"];
       
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"hasLoginKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _loginCreateButton.tag = _loginButtonTag;
       
      
    }
    [self hasLogin:YES];
    
}

- (void)authenticateUser {
   
   
    if ( [_username length] > 3 && [_password length] > 3) {
        NSString * passwordCheck = [_keychainWrapper objectForKey:@"password"];
        NSString * usernameCheck = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        if ([_password isEqualToString:passwordCheck]  && [_username isEqualToString:usernameCheck]) {
            
            _passwordTextField.text = @"";
            [self successfulLogin];
        }
    } else {
        
        [self alertUnsuccessfulAttempt];
    }

}
- (void)alertUnsuccessfulAttempt {
    NSLog(@"login attempt unsuccessful");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter name and password"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 _passwordTextField.text = @"";
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}


- (void)login {
    if (([_usernameTextField.text isEqualToString:@""]) || ([_passwordTextField.text isEqualToString:@""])) {
        [self alertUnsuccessfulAttempt];
       
        return;
    } else {
        if ([_usernameTextField.text length] > 4 ) {
            _username = _usernameTextField.text;
            if ([_passwordTextField.text length] > 4) {
                _password = _passwordTextField.text;
                 [self authenticateUser];
            }
            
        }
  
    }
}


- (void)loginWithTouchId {
    [_localAuthContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"Login with TouchID"
                      reply:^(BOOL success, NSError *error) {
                          
                          
                          if (success) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [self successfulLogin];
                              });
                              
                             
                              
                          } else {
                              
                              [self showTouchFailureReason:error];
                          }
                              
                          
                          
                      }];
}
- (void)successfulLogin {
    
    ParadiseViewController * paradiseVC = [[ParadiseViewController alloc] init];
    [self presentViewController:paradiseVC animated:NO completion:nil];

    
}

- (void)showTouchFailureReason:(NSError *)error {
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            NSLog(@"Authentication Failed");
            break;
            
        case LAErrorUserCancel:
            NSLog(@"User pressed Cancel button");
            break;
            
        case LAErrorUserFallback:
            NSLog(@"User pressed \"Enter Password\"");
            break;
            
        default:
            NSLog(@"Touch ID is not configured");
            break;
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
    _usernameTextField.text = @"";
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
    _passwordTextField.text = @"";
    [self.view addSubview:_passwordTextField];
    
    
    _loginCreateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginCreateButton.frame = CGRectMake(width * 0.45, height * 0.60, 100.0, 30.0);
    _loginCreateButton.hidden = NO;
    UIImage * buttonImage = [UIImage imageNamed:@"Button.png"];
    [_loginCreateButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_loginCreateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    
    _continueToLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _continueToLoginButton.frame = CGRectMake(width * 0.45, height * 0.70, 100.0, 30.0);
    _continueToLoginButton.hidden = NO;
    [_continueToLoginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_continueToLoginButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal ];

    
    _createInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.45,height * 0.50,100.0,24.0)];
    _createInfoLabel.text = @"Create User";
    [self.view addSubview:_loginCreateButton];
    //[self.view addSubview:_continueToLoginButton];
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
