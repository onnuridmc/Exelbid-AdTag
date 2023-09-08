#import "AdTagViewController.h"
#import "PostMessageInterface.h"

@interface AdTagViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) IBOutlet WKWebView *webView;
@property (nonatomic, strong) PostMessageInterface *postMessageInterface;

@end

@implementation AdTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _postMessageInterface = [[PostMessageInterface alloc] init];

    [_postMessageInterface setCoppa:NO];
    [_postMessageInterface setYob:nil];
    [_postMessageInterface setGender:@"M"];
    [_postMessageInterface setSegment:@"test" key:@"segment_01"];

    NSLog(@"toJSONString : %@", [_postMessageInterface toJSONString]);

    WKWebViewConfiguration *webviewConfiguration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];

    // Javascript에서 호출받을 핸들러 설정
    [userContentController addScriptMessageHandler:self name:@"mysdk"];

    [userContentController addUserScript:[[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"adTargetInfo=%@", [_postMessageInterface toJSONString]] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];

    webviewConfiguration.allowsInlineMediaPlayback = YES;
    webviewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAudio;
    [webviewConfiguration setUserContentController:userContentController];

    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webviewConfiguration];

    [_webView setUIDelegate:self];
    [_webView setNavigationDelegate:self];
    [self.view addSubview:_webView];

    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]]];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"----- didReceiveScriptMessage: %@ | %@", message.name, message.body);
    if ([message.name isEqualToString:@"mysdk"]) {
        [self.webView evaluateJavaScript:[NSString stringWithFormat:@"exelbidAdUnitInfo=%@", [_postMessageInterface toJSONString]] completionHandler:^(id result, NSError *error) {
            if (error != nil) {    // evaluateJavaScript 에러
                NSLog(@"evaluateJavaScript Error : %@", error.localizedDescription);
            } else if (result != nil){    // evaluateJavaScript 성공 및 응답값
                NSLog(@"evaluateJavaScript Success Result : %@", [NSString stringWithFormat:@"%@", result]);
            }
        }];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
