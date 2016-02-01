//
//  ViewController.m
//  TouchIDDemo
//
//  Created by Estelle Paus on 1/29/16.
//  Copyright © 2016 Estelle Paus. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (strong, nonatomic) FXKeychain * keychainWrapper;
@property (nonatomic,assign) int createButtonTag;
@property (nonatomic,assign) int loginButtonTag;
@property (nonatomic, strong) LAContext * localAuthContext;
@property (nonatomic) UIButton * loginCreateButton;
@property (nonatomic) UILabel * createInfoLabel;
@property (nonatomic) UITextField * usernameTextField;
@property (nonatomic) UITextField * passwordTextField;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _keychainWrapper = [FXKeychain defaultKeychain];

    [self setupUI];
    
    _loginButtonTag = 1;
    _createButtonTag = 0;
   
    BOOL hasLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLoginKey"];
    
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

    
    
    NSString * storeUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    
    NSError *error = nil;
    if ([_localAuthContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"can use touchID");
    }

}

- (void)createUser {


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
    
}
- (void)login {
    if (([_usernameTextField.text isEqualToString:@""]) || ([_passwordTextField.text isEqualToString:@""])) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Please enter name and password."] preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
       
        return;
    } else {
        if ([_usernameTextField.text length] > 4 ) {
            _username = _usernameTextField.text;
        }
        if ([_passwordTextField.text length] > 4) {
            _password = _passwordTextField.text;
        }

        if ( [_username length] > 0 && [_password length] > 0) {
            NSString * passwordCheck = [_keychainWrapper objectForKey:@"password"];
            NSLog(@"passwordCheck = %@",passwordCheck);
            NSString * usernameCheck = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
            if ([_password isEqualToString:passwordCheck]  && [_username isEqualToString:usernameCheck]) {
                NSLog(@"login successful");
                
                ParadiseViewController * paradiseVC = [[ParadiseViewController alloc] init];
                 [self presentViewController:paradiseVC animated:NO completion:nil];
                
                
            } else {
                NSLog(@"login unsuccessful");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"Try Again."] preferredStyle:UIAlertControllerStyleAlert];
                
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
        }
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
