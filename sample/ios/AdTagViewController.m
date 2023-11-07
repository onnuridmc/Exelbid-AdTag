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

#pragma mark - <WKScriptMessageHandler>

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

#pragma mark - <WKNavigationDelegate>

// WKWebView 내부 링크 이동 시
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    WKFrameInfo *targetFrame = navigationAction.targetFrame;

    NSLog(@"decidePolicyForNavigationAction URL : %@", [url absoluteString]);
    NSLog(@"decidePolicyForNavigationAction URL scheme : %@", [url scheme]);
    NSLog(@"decidePolicyForNavigationAction URL host : %@", [url host]);
    NSLog(@"decidePolicyForNavigationAction URL path : %@", [url path]);
    NSLog(@"decidePolicyForNavigationAction URL query : %@", [url query]);
    NSLog(@"decidePolicyForNavigationAction targetFrame : %@", navigationAction.targetFrame);

    if (url && targetFrame != nil && targetFrame.isMainFrame == YES) {
        // URL 채크
        if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
            // HTTP 링크

            // URL host 확인
            if ([[url host] isEqualToString:@"도메인"]) {
                // 같은 도메인

                // 허용 처리
                decisionHandler(WKNavigationActionPolicyAllow);

            } else {
                // 다른 도메인 (외부 브라우저로 열기)
                // 매체의 컨텐츠 도메인이 아닌경우 광고로 판단하여 광고 클릭 처리(외부 브라우저 처리)를 시도한다.

                // 차단 처리
                decisionHandler(WKNavigationActionPolicyCancel);

                @try {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (success) {
                            // 성공

                        } else {
                            // 실패

                        }
                    }];
                } @catch (NSException *error) {
                    // URL을 처리할 수 없는 경우
                }
            }
        } else {
            // scheme 링크 (외부 브라우저로 열기)
            // 매체의 컨텐츠 도메인이 아닌경우 광고로 판단하여 광고 클릭 처리(외부 브라우저 처리)를 시도한다.

            // 차단 처리
            decisionHandler(WKNavigationActionPolicyCancel);

            @try {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        // 성공
                        // 클릭 이벤트
                    } else {
                        // 실패

                    }
                }];
            } @catch (NSException *error) {
                // URL을 처리할 수 없는 경우
            }
        }
    } else {
        // 허용 처리
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// Window.popup, <a target="_blank"> 등 새창 이벤트
// 매체의 컨텐츠 도메인이 아닌경우 광고로 판단하여 광고 클릭 처리(외부 브라우저 처리)를 시도한다.
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSURL *url = navigationAction.request.URL;

    NSLog(@"createWebViewWithConfiguration URL : %@", [url absoluteString]);
    NSLog(@"createWebViewWithConfiguration URL scheme : %@", [url scheme]);
    NSLog(@"createWebViewWithConfiguration URL host : %@", [url host]);
    NSLog(@"createWebViewWithConfiguration URL path : %@", [url path]);
    NSLog(@"createWebViewWithConfiguration URL query : %@", [url query]);
    NSLog(@"createWebViewWithConfiguration targetFrame : %@", navigationAction.targetFrame);

    @try {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                // 성공

            } else {
                // 실패

            }
        }];
    } @catch (NSException *error) {
        // URL을 처리할 수 없는 경우
    }

    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
