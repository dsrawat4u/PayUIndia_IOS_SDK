//
//  PayUViewController.m
//  payU


#import "PayUViewController.h"
#include <CommonCrypto/CommonDigest.h>

@interface PayUViewController ()

@end

@implementation PayUViewController
@synthesize url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadAboutHTML
{
     NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"iFrame" ofType:@"html"]]];
    [web_view_PayU loadRequest:urlRequest];
    
}


-(NSString *)createSHA256:(NSString *)string
{
    
    const char *s=[string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}
- (void)viewDidLoad
{
    
    [self payUinitialize];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}




-(NSString *)createSHA512:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

-(void)payUinitialize
{
   
    int i = arc4random() % 9999999999;
    NSString *strHash = [self createSHA512:[NSString stringWithFormat:@"%d%@",i,[NSDate date]]];
    NSString *txnid1 = [strHash substringToIndex:20];
    NSLog(@"tnx1 id %@",txnid1);
    
    NSString *key = @"YOUR MERCHANT KEY";
    NSString* salt = @"YOUR SALT KEY";
    
    NSString *amount = @"1.00";
    NSString *productInfo = @"Nice product";
    NSString *firstname = @"Deepak Singh Rawat";
    NSString *email = @"dsrawat4u@gmail.com";
    NSString *phone = @"9212138007";
    NSString *surl = @"http://www.google.com/";
    NSString *furl = @"http://www.github.in/";
    

    
    
    
    NSString *hashValue = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|||||||||||%@",key,txnid1,amount,productInfo,firstname,email,salt];
    
    

    
    
    NSString *hash = [self createSHA512:hashValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txnid1,key,amount,productInfo,firstname,email,phone,surl,furl,hash
                                                                    , nil] forKeys:[NSArray arrayWithObjects:@"txnid",@"key",@"amount",@"productinfo",@"firstname",@"email",@"phone",@"surl",@"furl",@"hash", nil]];
    
  
    
    
  
    
    __block NSString *post = @"";
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([post isEqualToString:@""]) {
            post = [NSString stringWithFormat:@"%@=%@",key,obj];
        }else{
            post = [NSString stringWithFormat:@"%@&%@=%@",post,key,obj];
        }
        
    }];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://test.payu.in./_payment"]]];
    // change URL for live
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [web_view_PayU loadRequest:request];
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    activityind.hidden=FALSE;
    [activityind startAnimating];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    activityind.hidden=TRUE;
    
    [activityind stopAnimating];

    if (web_view_PayU.isLoading)
        return;
    NSURL *requestURL = [[web_view_PayU request] URL];
   
    NSLog(@"requestURL=%@",requestURL);
    

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtnAction:(id)sender
{
    [[self.view viewWithTag:55] removeFromSuperview];

    [self dismissViewControllerAnimated:NO completion:nil];
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
