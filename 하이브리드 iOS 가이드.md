
# 하이브리드 iOS 가이드

adTag 연동 관련 공통사항은 [Exelbid AdTag 연동 가이드](./README.md)를 참고해주세요.

---------

> iOS에서는 아래와 같이 "WKUserContentController"와 "WKWebView evaluateJavaScript"를 이용하여 데이터를 주고 받을 수 있습니다.
> 
> Javascript -> Webview 호출은 단방향입니다.  
> Webview -> Javascript 호출은 양방향입니다.  
> 
> Javascript에서 Webview의 값을 받으려면 호출될 함수(리시브) 설정이 필요합니다.

### 1. Webview -> Javascript
#### 1-1. Webview -> Javascript 호출 방법 1번 (문서 로드 시작시, 문서 로드 종료시 실행할 WKUserScript 설정)
```
WKWebViewConfiguration *webviewConfiguration = [[WKWebViewConfiguration alloc] init];
WKUserContentController *userContentController = [[WKUserContentController alloc] init];

// 호출할 Javascript 함수와 데이터 설정
// WKUserScriptInjectionTimeAtDocumentStart (문서 로드 시작시)
// WKUserScriptInjectionTimeAtDocumentEnd (문서 로드 종료시)
WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"FunctionName('%@')", @"Data"] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

// 호출할 WKUserScript 추가
[userContentController addUserScript:userScript];

[webviewConfiguration setUserContentController:userContentController];
    
self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webviewConfiguration];
```


#### 1-2. Webview -> Javascript 호출 방법 2번 (필요할때 WKWebView evaluateJavaScript 호출)
```
[self.webView evaluateJavaScript:[NSString stringWithFormat:@"FunctionName('%@')", @"Data"] completionHandler:^(id result, NSError *error) {
    if (error != nil) {    // evaluateJavaScript 에러
        NSLog(@"evaluateJavaScript Error : %@", error.localizedDescription);
    } else if (result != nil){    // evaluateJavaScript 성공 및 응답값
        NSLog(@"evaluateJavaScript Success Result : %@", [NSString stringWithFormat:@"%@", result]);
    }
}];
```

### 2. Javascript -> Webview
#### 2-1. Javascript -> Webview 호출 (WebView 설정)
```
// PostMessageInterface 생성(커스텀 클래스)
// Javascript에서 호추될 함수들을 정의 한 클래스
self.postMessageInterface = [[PostMessageInterface alloc] init]; 

WKWebViewConfiguration *webviewConfiguration = [[WKWebViewConfiguration alloc] init];
WKUserContentController *userContentController = [[WKUserContentController alloc] init];

// 웹이 호출할 메시지 핸들러 추가
[userContentController addScriptMessageHandler:self name:@"mysdk"];

// 설정한 WKUserContentController를 WKWebViewConfiguration에 설정
[webviewConfiguration setUserContentController:userContentController];
    
// 설정 정보를 WKWebView에 적용하여 웹뷰 생성
self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webviewConfiguration];
```



#### 2-2. Javascript -> Webview 호출 WKScriptMessageHandler Delegate 설정 (호출에 대한 리시브 설정 및 예시)
> WKUserContentController에 핸들러를 등록하지 않으면 응답받지 않음

```
@interface ViewController () <WKScriptMessageHandler>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // message.name = 핸들러 네임
    // message.body = 전달받은 메시지
    NSLog(@"----- didReceiveScriptMessage: %@ | %@", message.name, message.body);

    // 처리 예시
    if ([message.name isEqualToString:@"mysdk"]) {
        
        // body를 json형태로 구현하여 사용도 가능
        SEL selector = NSSelectorFromString(message.body);

        // PostMessageInterface에서 제공하는 함수가 있는지 확인
        if ([self.postMessageInterface respondsToSelector:selector]) {
            
            // Webview -> Javascript 호출 (completionHandler = nil 가능)
            // [self.postMessageInterface performSelector:selector]
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"FunctionName('%@')", @"Data"] completionHandler:^(id result, NSError *error) {
                if (error != nil) {    // evaluateJavaScript 에러
                    NSLog(@"evaluateJavaScript Error : %@", error.localizedDescription);
                } else if (result != nil){    // evaluateJavaScript 성공 및 결과
                    NSLog(@"evaluateJavaScript Success Result : %@", [NSString stringWithFormat:@"%@", result]);
                }
            }];

        }
    }
}
```

#### 2-3. Javascript -> Webview 호출 (window.webkit.messageHandlers 호출 - 단방향)
```
if (window.webkit && window.webkit.messageHandlers) {
    window.webkit.messageHandlers.mysdk.postMessage("Message");
}

// Webview에서 호출할 함수 선언
function FunctionName(data) {
    console.log(data);
    return "Data";
}
```

### 3. Hybrid지면 예시 코드
> 예시에서는 문서가 로드되기 전에 WebView -> Javascript 호출 방식으로 데이터를 전달하는 예시입니다.
> 
> 
> 
> 
> info.plist - 위치 사용 설정 추가
> ```
> Privacy - Location Always and When In Use Usage Description
> Privacy - Location When In Use Usage Description
> ```
>
> info.plist - 광고식별자 사용 설정 추가
> ```
> Privacy - Tracking Usage Description
> ```

### 3-1. Objective C
[[Exelbid PostMesageInterface.h 구현 예제 파일]](./sample/ios/PostMessageInterface.h)  
[[Exelbid PostMesageInterface.m 구현 예제 파일]](./sample/ios/PostMessageInterface.m)  
[[Exelbid AdTagViewController.m 구현 예제 파일]](./sample/ios/AdTagViewController.h)  
[[Exelbid AdTagViewController.m 구현 예제 파일]](./sample/ios/AdTagViewController.m)  
[[Exelbid HTML 구현 예제 파일]](./sample/ios/index.html)

# 광고 클릭 설정 가이드
기본적인 정의는 "광고 클릭 설정 가이드 (Android)"와 동일합니다.
- 페이지 이동 시 매체 컨텐츠 도메인과 동일하지 않은 이동 및 스킴에 대해 처리 로직을 정의한다.
- 별도 정의되지 않은 도메인 및 스킴은 광고라고 판단한다.
- `<a href target="_blank">`, `window.open()`등 새창 이동 처리 로직을 정의한다.

iOS WebView에서는 `새창 이동`을 제외하고 `페이지 이동` 이벤트가 2단계에 걸쳐 발생합니다.  
WebView에서 발생한 페이지 이동은 iFrame 내 발생한 이벤트도 포함되며 메인프레임인지 아닌지로 구분합니다.

## 페이지 이동, 새창 이동 이벤트 정의 - `WKNavigationDelegate`
1. WKWebView 페이지 이동 - webView:decidePolicyForNavigationAction:decisionHandler:
2. WKWebView 새창 이동 - webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:


## 샘플코드
### [[샘플코드 - AdTagViewController.m 구현 예제 파일]](./sample/ios/AdTagViewController.m)

#### 1. WKWebView 페이지 이동 - webView:decidePolicyForNavigationAction:decisionHandler:
``` 
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    WKFrameInfo *targetFrame = navigationAction.targetFrame;

    if (url) {
        NSLog(@"decidePolicyForNavigationAction URL : %@", [url absoluteString]);
        NSLog(@"decidePolicyForNavigationAction URL scheme : %@", [url scheme]);
        NSLog(@"decidePolicyForNavigationAction URL host : %@", [url host]);
        NSLog(@"decidePolicyForNavigationAction URL path : %@", [url path]);
        NSLog(@"decidePolicyForNavigationAction URL query : %@", [url query]);
        NSLog(@"decidePolicyForNavigationAction targetFrame : %@", navigationAction.targetFrame);

        // 대상 프레임이 존재하며 메인프레임(최상위 Document)일 경우
        if (targetFrame != nil && targetFrame.isMainFrame == YES) {
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

                        } else {
                            // 실패

                        }
                    }];
                } @catch (NSException *error) {
                    // URL을 처리할 수 없는 경우
                }
            }
        } else {
            // 새창 이벤트 또는 메인 프레임이 아닌곳에서 페이지 이동
            // 기본적으로 허용 처리
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }

}
```

#### 2. WKWebView 새창 이동 - webView:createWebViewWithConfiguration:forNavigationAction:windowFeatures:
```
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSURL *url = navigationAction.request.URL;

    @try {
        NSLog(@"createWebViewWithConfiguration URL : %@", [url absoluteString]);
        NSLog(@"createWebViewWithConfiguration URL scheme : %@", [url scheme]);
        NSLog(@"createWebViewWithConfiguration URL host : %@", [url host]);
        NSLog(@"createWebViewWithConfiguration URL path : %@", [url path]);
        NSLog(@"createWebViewWithConfiguration URL query : %@", [url query]);
        NSLog(@"createWebViewWithConfiguration targetFrame : %@", navigationAction.targetFrame);

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
```




