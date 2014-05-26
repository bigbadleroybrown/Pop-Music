//
//  VisualizerViewController.m
//  musicVisualizedV.2
//
//  Created by Eugene Watson on 5/26/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "VisualizerViewController.h"
#import "FBShimmeringView.h"

@interface VisualizerViewController ()
@property (weak, nonatomic) IBOutlet UIView *visualizerview;



@end

@implementation VisualizerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupShimmerView];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)setupShimmerView

{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.view.bounds];
    shimmeringView.shimmeringOpacity = 0.2;
    
    [self.visualizerview addSubview:shimmeringView];
    self.visualizerview.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"Visualizer", nil);
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60.0];
    titleLabel.textColor = [UIColor blackColor];
    shimmeringView.contentView = titleLabel;
    
    shimmeringView.shimmering = YES;
    
}

- (IBAction)dimissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
