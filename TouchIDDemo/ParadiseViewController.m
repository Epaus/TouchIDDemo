//
//  ParadiseViewController.m
//  TouchIDDemo
//
//  Created by Estelle Paus on 1/29/16.
//  Copyright © 2016 Estelle Paus. All rights reserved.
//

#import "ParadiseViewController.h"

@interface ParadiseViewController ()
@property ( nonatomic) IBOutlet UIImageView *backgroundImageView;
@property ( nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) UIButton * exitButton;

@end

@implementation ParadiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ParadiseVC::viewDidLoad");
    UIImage * backgroundImage = [UIImage imageNamed:@"paradise.png"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(46.0,463.0,700,129)];
    _titleLabel.text = @"Welcome to this password protected paradise.";
    _titleLabel.textColor = [UIColor whiteColor];
    //[_titleLabel setFont:[UIFont fontWithName:@"System" size:30]];
    [_titleLabel setFont: [_titleLabel.font fontWithSize: 30]];
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_titleLabel];
    
    _exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _exitButton.frame = CGRectMake(900.0,700.0, 100.0, 30.0);
    _exitButton.hidden = NO;
    [_exitButton setTitle:@"Exit" forState:UIControlStateNormal];
    UIImage * buttonImage = [UIImage imageNamed:@"Button.png"];
    [_exitButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [_exitButton addTarget:self
                           action:@selector(byeBye)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitButton];


}

- (void)byeBye {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
