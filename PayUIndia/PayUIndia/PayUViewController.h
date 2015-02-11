//
//  PayUViewController.h
//  payU


#import <UIKit/UIKit.h>

@interface PayUViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *web_view_PayU;
    IBOutlet UIActivityIndicatorView*activityind;
    NSTimer *timer;
    NSURL *url ;
}
@property(nonatomic,retain)NSURL *url;
-(IBAction)backBtnAction:(id)sender;
@end
