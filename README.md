
# Exelbid AdTag 연동 가이드
## 시작하기

1. 계정을 생성합니다. (https://manage.exelbid.com) 
2. Inventory -> App -> + Create New App을 선택합니다.<br/>
![new app](./img/sdk-1.png)

3. 앱정보를 등록시 <br>
Web은 Channel -> WEB,<br> 
Hybrid는 Channel->INAPP 으로 설정한다.<br>
 ![new app](./img/channel.png)
4. unit을 생성 후, Unitid(TAG_ID)를 이용하여 Adtag 연동을 진행합니다.<br>
 ![new app](./img/unit.png)
 
5. Passback 설정(선택) <br>
광고가 없을시 아래와 같이 설정된 Passback 코드가 적용 됩니다.<br>
 ![new app](./img/passback.png)


> 헤더와 헤더 사이 혹은 가장 먼저 넣습니다.
```html
<script type='text/javascript'>
    !function (w,d,s,u,t,ss,fs) {
        if(w.exelbidtag)return;t=w.exelbidtag={};if(!window.t) window.t = t;
        t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
        t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
        fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
    }(window,document,'script','https://st2.exelbid.com/js/ads.js');
</script>
```
ads.js는 ***HTTPS 프로토콜*** 에서 동작합니다. 기타 다른 프로토콜에서 동작하지 않으니 스크립트 삽입 시 프로토콜을 확인해 주시길 바랍니다.

> 광고 태그를 선언합니다.
```html
<script type='text/javascript'>
    // You can get add request result
    function ExelbidResponseCallback_${TAG_ID}(result){
        // alert('status :' + status);
        if(result.status == 'OK'){
            console.log('OK');
        }else if(result.status == 'NOBID'){
            console.log('NOBID');
        }else if(result.status == 'ERROR'){
            console.log('ERROR');
        }
    };
    exelbidtag.push(function () {
        exelbidtag.initAdBanner('${TAG_ID}', ${WIDTH}, ${HEIGHT}, 'div-exelbid-${TAG_ID}')
            .setResponseCallback(ExelbidResponseCallback_${TAG_ID});
    });
</script>
<!-- Ad Space -->
<div id='div-exelbid-${TAG_ID}'>
    <script type='text/javascript'>
        exelbidtag.push(function () {
            exelbidtag.loadAd('${TAG_ID}');
        });
    </script>
</div>
```
## 함수 설명
> 모든 함수는 exelbidAdUnit 객체를 반환한다.

 함수 | required | Description | Ex                     
:-------|:-------------|:--------------------------|:-----------
initAdBanner | O | 배너를 초기화한다. tagid, width, height, ad_container 순으로넘겨줍니다. | 
loadAd | O | 광고를 요청한다. 만약 결과를 받고 싶으면 setResponseCallback 를 사용하면 된다. | 
setResponseCallback | | 콜백함수를 지원한다. OK, NOBID, ERROR 를 리턴해준다. | 
setPassbackFunc | | 로컬 Passback 함수를 설정한다. 설정시 서버 설정 패스백이 무시된다. | setPassbackFunc(ExelbidPassback_abcdefg);
setYob |  | 유저의 테어난 년도를 알고 있다면 입력한다. | setYob('1990')
setGender |  | 유저의 성별을 알고 있다면 입력한다. M,F 만 지원한다. | setGender('M')
addKeyword |  | 자체 세그먼트가 존재한다면 Key-Value 형태로 넣는다. | addKeyword('favorite', 'golf')
setTestMode |  | 개발 중에 사용할 테스트 모드이다. | setTestMode(true)
setIsInApp | O (Hyb) | 하이브리드 앱 일 경우 true 필수 | setIsInApp(true)
setIfa | O (Hyb) | 하이브리드 앱 일 경우필수. 광고 식별자 gaid 또는 idfa | setIfa('9473b438-c752-4beb-ba21-80ef9353e8bc')
setCoppa |  | DO_NOT_TRACK isLimitAdTrackingEnabled | setCoppa(true)
setMobileCountryCode |  | Mobile Country Code 국가 번호 | setMobileCountryCode('450')
setMobileNetworkCode |  | Mobile Network Code 통신사 번호 | setMobileNetworkCode('50')
setDeviceModel |  | 단말기 모델 정보 | setDeviceModel('SM-N920K')
setDeviceMake |  | 단말기 제조사 정보 | setDeviceMake('LGE')
setOsVersion |  | Android 또는 iOS의 os 버전 | setOsVersion('4.3.0')
setAppVersion |  | 어플리케이션 버전 | setAppVersion('2.3.4')
setGeo |  | LAT_LONG_KEY (latitude,longitude) 위도, 경도 | setGeo('35.2456226,128.9077138')

## Web Example
> tagid : "abcdefg", width : 320, height : 50 이고 데이타 관련 함수를 전부 썼을때에는
아래와 같습니다.
```html
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type='text/javascript'>
        !function (w,d,s,u,t,ss,fs) {
            if(w.exelbidtag)return;t=w.exelbidtag={};if(!window.t) window.t = t;
            t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
            t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
            fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
        }(window,document,'script','https://st2.exelbid.com/js/ads.js');
    </script>
</head>

<body>
    <script type='text/javascript'>
        function ExelbidResponseCallback_abcdefg(result){
            // alert('status :' + status);
            if(result.status == 'OK'){
                console.log('OK');
            }else if(result.status == 'NOBID'){
                console.log('NOBID');
            }else if(result.status == 'ERROR'){
                console.log('ERROR');
            }
        };
        
        /*
        // local passback 을 설정하면 서버의 설정이 무시됩니다.
        // local passback 설정 시 광고가 Parent Node에 영향을 미치지 않도록 Iframe 내 Passback 호출을 권장드립니다.
        // Passback 함수 - setResponseCallback(ExelbidPassback_abcdefg)와 같이 설정
        function ExelbidPassback_abcdefg(){
            // TODO
            // document.getElementById('div-exelbid-abcdefg').innerHTML = "<iframe src='http://xxx.com/banner/passback.html?a=5' scrolling='no' frameborder='0' width='100%' height='450px'>";
        };
        */
        exelbidtag.push(function () {
            exelbidtag.initAdBanner('abcdefg', 320, 50, 'div-exelbid-abcdefg')
                .setYob('1976')
                .setGender('M')
                .addKeyword('target1', 'value1')
                .addKeyword('target2', 'value2')
                .setResponseCallback(ExelbidResponseCallback_abcdefg)
                //.setPassbackFunc(ExelbidPassback_abcdefg);
                .setTestMode(true);
        });
    </script>
    <div id='div-exelbid-abcdefg'>
        <script type='text/javascript'>
            exelbidtag.push(function () {
                exelbidtag.loadAd('abcdefg');
            });
        </script>
    </div>
</body>

</html>
```
## Hybrid Example(Android)
> Hybrid에서는 광고 아이디(gaid or idfa)등의 전달의 필요합니다.<br>
 Android 에서는 아래와 같이 Javascriptinterface를 이용하여 webview와 Native 간에 데이터를 주고 받을 수 있습니다. 

1. Javainterface 클래스를 구현
### Javainterface 예제 [[Exelbid WebViewInterface 구현 예제 파일]](./sample/ExelbidWebViewInterface.java)
```java
public class WebViewInterface {
 
    private WebView mAppView;
    private Activity mContext;
 
    public WebViewInterface(Activity activity, WebView view) {
        mAppView = view;
        mContext = activity;
    }

    @JavascriptInterface public String getIfa();
    @JavascriptInterface public boolean isCoppa();
    @JavascriptInterface public boolean hasYob();
    @JavascriptInterface public String getYob();
    @JavascriptInterface public boolean hasGender();
    @JavascriptInterface public String getGender();
    @JavascriptInterface public boolean hasSegment();
    @JavascriptInterface public Map<String, String> getSegment();
    @JavascriptInterface public boolean hasMobileCountryCode();
    @JavascriptInterface public String getMobileCountryCode();
    @JavascriptInterface public boolean hasMobileNetworkCode();
    @JavascriptInterface public String getMobileNetworkCode();
    @JavascriptInterface public boolean hasCountryIso();
    @JavascriptInterface public String getCountryIso();
    @JavascriptInterface public boolean hasDeviceModel();
    @JavascriptInterface public String getDeviceModel();
    @JavascriptInterface public boolean hasDeviceMake();
    @JavascriptInterface public String getDeviceMake(;
    @JavascriptInterface public boolean hasOsVersion();
    @JavascriptInterface public String getOsVersion();
    @JavascriptInterface public boolean hasAppVersion();
    @JavascriptInterface public String getAppVersion();
    @JavascriptInterface public boolean hasGeo();
    @JavascriptInterfacepublic String getLat();
    @JavascriptInterface public String getLon();
}
```
2. Native(Activity)d의 WebView에 JavascriptInterface 연결 - WebViewInterface(Javascripinterface)를 'mysdk'라는 이름으로 연결
```java
public class MainActivity {
 
    private WebView mWebView = null;
    private WebViewInterface mWebViewInterface;
 
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().requestFeature(Window.FEATURE_PROGRESS);
        setContentView(R.layout.activity_main);
        mWebView = (WebView) findViewById(R.id.webview); //웹뷰 객체
        mWebViewInterface = new WebViewInterface(MainActivity.this, mWebView); //JavascriptInterface 객체화
        mWebView.addJavascriptInterface(mWebViewInterface, "mysdk"); //웹뷰에 JavascriptInterface를 연결
    }
}
```
3-1. Hybrid지면의 영역이 고정값(불변값)인 경우
 - width, height 값이 고정값(px)인 경우 javascriptinterface를 이용하여 데이타 관련 함수를 전부 썼을때에는 아래와 같습니다.

- ex) tagid : "abcdefg", width : 320px, height : 50px
```html
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type='text/javascript'>
          !function (w,d,s,u,t,ss,fs) {
            if(w.exelbidtag)return;t=w.exelbidtag={};if(!window.t) window.t = t;
            t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
            t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
            fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
        }(window,document,'script','https://st2.exelbid.com/js/ads.js');
    </script>
</head>

<body>
    <script type='text/javascript'>
        function MyResponse(result) {
            // alert('status :' + status);
            if (result.status == 'OK') {
                //TODO 광고 처리 됨
            } else if (result.status == 'NOBID') {
                //TODO 광고없음
            } else if (result.status == 'PASSBACK') {
                //TODO PASSBACK
            } else if (result.status == 'ERROR') {
                //TODO 기타 에러
            }
        };

        exelbidtag.push(function () {
            var adunit = exelbidtag.initAdBanner('abcdefg', 320, 50, 'div-exelbid-abcdefg')
                .setResponseCallback(MyResponse)
                .setIsInApp(true); // 이것은 특별히 inapp 인 경우 반드시 해줘야 합니다. 

            if( typeof mysdk === 'undefined' )
            {
                console.log("error occured in mysdk object");
            }else 
            {
                adunit.setIfa(mysdk.getIfa()); // ifa(gaid or idfa) 가 없는 경우는 입찰이 거의 들어오지 않습니다.

                if (mysdk.isCoppa())
                    adunit.setCoppa(true);
                if (mysdk.hasYob()) // ex) 1990
                    adunit.setYob(mysdk.getYob());
                if (mysdk.hasGender()) // ex) F, M
                    adunit.setGender(mysdk.getGender());
                if (mysdk.hasSegment()) // ex) seg1, 0012
                    adunit.addKeyword(mysdk.getSegmentKey(), mysdk.getSegmentValue());
                if (mysdk.hasMobileCountryCode()) // ex 450
                    adunit.setMobileCountryCode(mysdk.getMobileCountryCode());
                if (mysdk.hasMobileNetworkCode()) // ex 05
                    adunit.setMobileNetworkCode(mysdk.getMobileNetworkCode());
                if (mysdk.hasCountryIso()) // ex kr
                    adunit.setCountryIso(mysdk.getCountryIso());
                if (mysdk.hasDeviceModel()) // ex SM-N920K
                    adunit.setDeviceModel(mysdk.getDeviceModel());
                if (mysdk.hasDeviceMake()) // ex LGE
                    adunit.setDeviceMake(mysdk.getDeviceMake());
                if (mysdk.hasOsVersion()) // ex 7.0.1
                    adunit.setOsVersion(mysdk.getOsVersion());
                if (mysdk.hasAppVersion()) // ex 1.0.2
                    adunit.setAppVersion(mysdk.getAppVersion());
                if (mysdk.hasGeo()) // ex 37.01, 127.501
                    adunit.setGeo(mysdk.getLat(), mysdk.getLon());
            }
        });
    </script>
        <!--
        #div-exelbid-abcdefg 의 영역이 광고 영역입니다.
        div에 Height CSS 속성을 설정하지 마세요.
        -->
    <div id='div-exelbid-abcdefg' style="width: 320px;">
        <script type='text/javascript'>
            exelbidtag.push(function () {
                exelbidtag.loadAd('abcdefg');
            });
        </script>
    </div>
</body>

</html>
```

3-2. Hybrid지면의 영역이 가변값인 경우
 - width 값이 가변값(%)인 경우 javascriptinterface를 이용하여 데이타 관련 함수를 전부 썼을때에는 아래와 같습니다. &nbsp; 단, height값은 고정값으로 들어가야 합니다.

- ex) tagid : "abcdefg", width : 100%, height : 200px

```html
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type='text/javascript'>
          !function (w,d,s,u,t,ss,fs) {
            if(w.exelbidtag)return;t=w.exelbidtag={};if(!window.t) window.t = t;
            t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
            t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
            fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
        }(window,document,'script','https://st2.exelbid.com/js/ads.js');
    </script>
</head>

<body>
    <script type='text/javascript'>
        function MyResponse(result) {
            // alert('status :' + status);
            if (result.status == 'OK') {
                //TODO 광고 처리 됨
            } else if (result.status == 'NOBID') {
                //TODO 광고없음
            } else if (result.status == 'PASSBACK') {
                //TODO PASSBACK
            } else if (result.status == 'ERROR') {
                //TODO 기타 에러
            }
        };

        exelbidtag.push(function () {
            var adunit = exelbidtag.initAdBanner('abcdefg', '100%', 200, 'div-exelbid-abcdefg')
                .setResponseCallback(MyResponse)
                .setIsInApp(true); // 이것은 특별히 inapp 인 경우 반드시 해줘야 합니다. 

            if( typeof mysdk === 'undefined' )
            {
                console.log("error occured in mysdk object");
            }else 
            {
                adunit.setIfa(mysdk.getIfa()); // ifa(gaid or idfa) 가 없는 경우는 입찰이 거의 들어오지 않습니다.

                if (mysdk.isCoppa())
                    adunit.setCoppa(true);
                if (mysdk.hasYob()) // ex) 1990
                    adunit.setYob(mysdk.getYob());
                if (mysdk.hasGender()) // ex) F, M
                    adunit.setGender(mysdk.getGender());
                if (mysdk.hasSegment()) // ex) seg1, 0012
                    adunit.addKeyword(mysdk.getSegmentKey(), mysdk.getSegmentValue());
                if (mysdk.hasMobileCountryCode()) // ex 450
                    adunit.setMobileCountryCode(mysdk.getMobileCountryCode());
                if (mysdk.hasMobileNetworkCode()) // ex 05
                    adunit.setMobileNetworkCode(mysdk.getMobileNetworkCode());
                if (mysdk.hasCountryIso()) // ex kr
                    adunit.setCountryIso(mysdk.getCountryIso());
                if (mysdk.hasDeviceModel()) // ex SM-N920K
                    adunit.setDeviceModel(mysdk.getDeviceModel());
                if (mysdk.hasDeviceMake()) // ex LGE
                    adunit.setDeviceMake(mysdk.getDeviceMake());
                if (mysdk.hasOsVersion()) // ex 7.0.1
                    adunit.setOsVersion(mysdk.getOsVersion());
                if (mysdk.hasAppVersion()) // ex 1.0.2
                    adunit.setAppVersion(mysdk.getAppVersion());
                if (mysdk.hasGeo()) // ex 37.01, 127.501
                    adunit.hasGeo(mysdk.getLat(), mysdk.getLon());
            }
        });
    </script>

    <!--
        #div-exelbid-abcdefg 의 영역이 광고 영역입니다.
        div에 Height CSS 속성을 설정하지 마세요.
    -->
    <div id='div-exelbid-abcdefg' style="width: 100%;">
        <script type='text/javascript'>
            exelbidtag.push(function () {
                exelbidtag.loadAd('abcdefg');
            });
        </script>
    </div>
</body>

</html>
```

## Hybrid Example(iOS)
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

## NATIVE MOBILE WEB
> MOBILE WEB 지면에서 NATIVE 광고를 적용 할 때<br>

HTML Template 설정
- adtag 설정은 기존 설정 방법과 똑같고, MOBILE WEB 지면 영역에 맞는 템플릿 별도 설정 해줘야함.
아래는 예시 샘플 HTML
 
 ```html
<!DOCTYPE html>
 <html>
 
 <head>
   <title>${TITLE}</title>
   <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
   <meta name='viewport' content='width=device-width, initial-scale=1.0'>
   <style>
 
     body {
       margin: 0;
       border: 0;
       overflow: hidden;
     }
 
     #body {
       position: relative;
       min-width: 300px;
       max-width: 500px;
     }
 
     #optout {
       position: relative;
       width: 16px;
       height: 16px;
       margin-left: auto;
       content: url('${OPTOUT_IMG}');
     }
 
     #main_container{
       height: 120px;
       padding: 0 30px;
       background-color: #f7f7f7;
       display: flex;
       align-items: center;
     }
 
     #icon_wrapper {
       display: flex;
       align-items: center;
       border-radius: 4px;
       flex: 1;
     }
 
     #icon_wrapper #icon{
       width: 56px;
       height: 56px;
       background-color: white;
     }
 
     #title_container{
       flex: 8;
       padding: 0 30px;
       max-width: 70%;
       min-width: 40%;
     }
 
     #title_wrapper{
       display: flex;
     }
 
     #title_container #title_wrapper #title {
       font-size: 14px;
       margin: 0 0 5px 0;
       overflow: hidden;
       text-overflow: ellipsis;
       word-break: keep-all;
       max-width: 80%;
     }
 
     #title_container #desc {
       font-size: 10px;
       margin: 0;
       overflow: hidden;
       text-overflow: ellipsis;
       word-break: keep-all;
       display: -webkit-box;
       -webkit-line-clamp: 2;
       -webkit-box-orient: vertical;
     }
 
     #cta_wrapper{
       flex: 1;
     }
     #cta_wrapper #cta{
       width: 77px;
       height: 45px;
       display: flex;
       align-items: center;
       justify-content: center;
       border: none;
       border-radius: 4px;
       background-color: #009aff;
     }
 
     #cta_wrapper #cta:after{
       content: '${CTATEXT}';
       color: white;
       font-weight: bold;
       overflow: hidden;
       text-overflow: ellipsis;
       display: -webkit-box;
       -webkit-line-clamp: 1;
       -webkit-box-orient: vertical;
     }
 
     .overlay {
       position: absolute;
       left: 0;
       top: 0;
       width: 100%;
       height: 100%;
     }
 
   </style>
 </head>
 
 <body>
   <div id='body'>
    <!--
    광고 클릭 트래킹 URL 사용할 경우 
    id="useClickTrackingUrl" 를 추가, 하단 이벤트 리스너 추가 할 것
    -->
     <a class='overlay' id="useClickTrackingUrl" href='${CLICK_URL}' target='_blank'></a>
     <div id='main_container'>
       <div id='icon_wrapper'>
         <img id='icon' src='${IMG_ICON}' />
       </div>
       <div id='title_container'>
         <div id='title_wrapper'>
           <h5 id='title'>${TITLE}</h5>
           <a id='optout' href='${OPTOUT_URL}' target='_blank'></a>
         </div>
         <span id='desc'>${DESC}</span>
       </div>
       <div id='cta_wrapper'>
         <button id='cta'></button>
       </div>
     </div>
   </div>
   <script type='text/javascript'>
     /**
      * 광고 impression을 위해 하단 스크립트는 필수로 삽입
      * */
     try{var tags = new Array();var imgs = new Array();tags=[${ADTAG_MACRO_IMPRESSION_TAGS}];for(var i = 0; i < tags.length; i++ ){imgs[i] = new Image();imgs[i].src = tags[i];}}catch(e){}
   </script>
    
    <script type="text/javascript">
    /**
     * 광고 클릭 트래킹 URL 사용할 경우 해당 이벤트 리스너 추가 할 것
     * */
    document.getElementById("useClickTrackingUrl").addEventListener("click", function() {
        try{var clickTags = new Array();var imgObj = new Array();clickTags=[${ADTAG_MACRO_CLICK_TAGS}];for(var i = 0; i < clickTags.length; i++ ){imgObj[i] = new Image();imgObj[i].src = clickTags[i];}}catch(e){}
    </script>
 </body>
 
 </html>

 ```
 Macro 설명

- ${TITLE}  : HTML TITLE 영역
- ${IMG_ICON} : 광고 아이콘 이미지
- ${IMG_MAIN} : 광고 메인 이미지
- ${CLICK_URL} : 광고 클릭 URL
- ${DESC} : 광고 DESCRIPTION
- ${CTATEXT} : CTATEXT
- ${OPTOUT_URL} : OPTOUT URL 
- ${OPTOUT_IMG} : OPTOUT IMAGE
- ${CREATIVE_ID} : 소재 ID
- ${CAMPAIGN_ID} : 캠페인 ID
<br><br>


# 광고 클릭 설정 가이드 (Android)

광고 클릭 시, 클릭이 외부 브라우저로 동작하기 위해서는 다음과 같은 추가 설정이 필요합니다.

1. `WebViewClient`의 `shouldOverrideUrlLoading` 메서드 Overriding 구현
    
    광고에 의한 페이지 이동은 외부 브라우저로 처리되도록 `shouldOverrideUrlLoading overriding 샘플코드`와 같은 로직을 구현해주세요.<br>
    [샘플 코드의 'shouldOverrideUrlLoading' 참조](#샘플-코드)
    
2. `WebView` 의 `setSupportMultipleWindows` 세팅 true 인 경우도 구현된 새탭의 `WebViewClient`의 `shouldOverrideUrlLoading` 메서드 Overriding 구현로직을 구현해주세요.<br>
    [샘플 코드의 'onCreateWindow'에서 새탭의 'shouldOverrideUrlLoading' 참조](#샘플-코드)

    - `setSupportMultipleWindows` 를 true 설정하면 링크가 _blank로 동작할때 새탭으로 이동하려고 한다. <br>
        이때 새탭에 대한 구현이 없다면 오류발생(클릭 반응 없음)
     

3. 광고에 대한 클릭 처리 로직(외부 브라우저 처리)<br>

    [샘플 코드의 'onClickAd' 참조](#클릭-처리-코드)<br>

    클릭 발생 시, 광고에 대한 클릭 처리 로직은 다음과 같습니다.

    - 이동하는 url 이 매체의 컨텐츠 도메인(host) 혹은 스킴(scheme)인 경우
        
        - 매체 자체의 페이지 로직 혹은 default 세팅에 따라 동작

        - 다음 예시와 같은 케이스를 매체의 컨텐츠 도메인으로 판단한다.
        
            ex) 매체의 컨텐츠 도메인이 mysite.com 이고, 이동할 url이 http://mysite.com/page.html 인 경우

            이동하는 url host가 매체의 컨텐츠 도메인과 같으므로, 매체 자체의 페이지 로직에 따라 동작한다.
        
    - 이동하는 url 이 매체의 컨텐츠 도메인 혹은 스킴이 아닌 경우
        
        - 해당 url 이동을 광고로 인한 페이지 이동으로 판단하여, 외부 브라우저 처리

        - 다음 예시와 같은 케이스를 광고로 판단한다.

            ex) 매체의 컨텐츠 도메인이 mysite.com 이고, 이동할 url이 http://m.naver.com 또는 market://details?id=com.google.android.youtube 와 같이 외부 컨텐트인 경우

            이동하는 url 을 매체의 컨텐츠가 아닌 광고로 인한 페이지 이동으로 판단하여, 외부 브라우저 처리한다.
    

## 샘플 코드

```java
public class MainActivity extends AppCompatActivity {

  private WebView mWebView;

  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
		
		...

		mWebView = new WebView(this);
		WebSettings webSettings = mWebView.getSettings();
		
		//WebViewClient의 shouldOverrideUrlLoading 메서드를 재정의한다
        	mWebView.setWebViewClient(new WebViewClient(){
	    	@Override
	    	public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
		    Context context = view.getContext();
	
		    // 1. 매체의 컨텐츠 도메인을 조회한다 (ex. "mysite.com")
		    String myHost = "mysite.com";
	
	            // 2. 이동하는 uri의 host를 조회한다
		    Uri uri = request.getUrl();
		    String host = uri.getHost();
	
		    // 3. 매체 컨텐츠인지 광고인지에 따라 클릭 처리
		    if (host.contains(myHost)) {
	            	// 3-1. 매체의 컨텐츠 도메인(host)인 경우: 매체 자체의 페이지 로직 혹은 디폴트 세팅에 따라 처리한다.
		    } else {
		    	// 3-2. 매체의 컨텐츠 도메인(host)이 아닌 경우: 광고로 판단하여 광고 클릭 처리(외부 브라우저 처리)를 시도한다.
		    if(clickAd(context, uri)){
			// 광고 클릭 성공에 대한 처리
			return true;
		    }
                }

                return super.shouldOverrideUrlLoading(view, request);
            }
        });

        // `WebView` 의 `setSupportMultipleWindows` 세팅 true 인 경우
        // 구현된 새탭의 WebViewClient의 shouldOverrideUrlLoading 메서드를 재정의한다 
        mWebView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
                // 새로운 창을 띄울 시, 새로운 웹뷰를 정의한다.
                WebView newWebView = new WebView(view.getContext());
                WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;
                transport.setWebView(newWebView);
                resultMsg.sendToTarget();

                // 새로운 웹뷰에 대해 WebViewClient의 shouldOverrideUrlLoading 메서드를 재정의한다
                newWebView.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                        Context context = view.getContext();

                        // 1. 매체의 컨텐츠 도메인을 조회한다 (ex. mysite.com)
                        String myHost = "mysite.com";

                        // 2. 이동하는 uri의 host를 조회한다
                        Uri uri = request.getUrl();
                        String host = uri.getHost();

                        // 3. 매체 컨텐츠인지 광고인지에 따라 클릭 처리
                        if (host.contains(myHost)) {
                            // 3-1. 매체의 컨텐츠 도메인(host)인 경우: 매체 자체의 페이지 로직 혹은 디폴트 세팅에 따라 처리한다.
                        } else {
                            // 3-2. 매체의 컨텐츠 도메인(host)이 아닌 경우: 광고로 판단하여 광고 클릭 처리(외부 브라우저 처리)를 시도한다.
                            if(clickAd(context, uri)){
                                // 광고 클릭 성공에 대한 처리
                                return true;
                            }
                        }

                        //3-2. 매체의 컨텐츠 도메인(host)인 경우: 매체 자체의 페이지 로직 혹은 디폴트 세팅에 따라 처리한다.
                        return super.shouldOverrideUrlLoading(view, request);
                    }
                });

                return true;
            }
        });
	}

    private boolean clickAd(Context context, Uri uri){
        // 클릭 처리 코드(광고 클릭에 대한 외부 브라우저 호출) 참조
    }
    
}

```


## 클릭 처리 코드
- 광고 클릭에 대한 외부 브라우저 호출
- 광고 클릭 처리 함수(`clickAd`)구현 샘플 코드
```java
    // 광고 클릭 처리 함수 구현. 광고에 대한 페이지 이동은 외부 브라우저로 처리한다. (클릭 성공 시, true. 클릭 실패 시, false 반환)
    private boolean clickAd(Context context, Uri uri){

        Intent intent = null;

        // 1. 실행 가능한 앱이 있으면 실행한다.
        try {
            intent = Intent.parseUri(uri.toString(), Intent.URI_INTENT_SCHEME);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. 실행 가능한 앱이 없는 경우, intent 스킴이라면 이동할 대체 url을 생성한다. (fallback_url 혹은 market_url)
        if(intent.getScheme().equalsIgnoreCase("intent")){
            String fallbackUrl = intent.getStringExtra("browser_fallback_url");
            if (!TextUtils.isEmpty(fallbackUrl)) {
                // 2.1. fallback_url 있는 경우
                uri = Uri.parse(fallbackUrl);
            } else {
                // 2.2. fallback_url 없는 경우
                String targetPackage = intent.getPackage();
                // 2.2.1. 패키지 정보도 없으면 클릭 실패 처리
                if (TextUtils.isEmpty(targetPackage)) {
                    return false;
                }
                // 2.2.2. 패키지 정보가 있으면 market_url 로 대체
                String marketUrl = "market://details?id=" + targetPackage;
                uri = Uri.parse(marketUrl);
            }

            // 3. fallback_url 혹은 market_url 로 다시 클릭을 시도한다. 실행 가능한 앱이 있으면 실행한다.
            try {
                intent = Intent.parseUri(uri.toString(), Intent.URI_INTENT_SCHEME);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 4. 클릭 실패 처리
        return false;
    }
```

# 광고 클릭 설정 가이드 (iOS)
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




