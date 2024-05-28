
# 하이브리드 ANDROID 가이드

adTag 연동 관련 공통사항은 [Exelbid AdTag 연동 가이드](./README.md)를 참고해주세요.

---------

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

## 광고 클릭 설정 가이드

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
