//
//  ViewController.m
//  PayUIndia
//


#import "ViewController.h"
#import "PayUViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)openPayU:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                             bundle: nil];
    PayUViewController *vc;// =[[UIViewController alloc]init];
    
    vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"PayUViewController"];
    [self presentViewController:vc animated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
