
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

 # 하이브리드 앱
> 하이브리드 앱 설정은 os 별 가이드를 참고해주세요

- [ANDROID 가이드](./android%20%EA%B0%80%EC%9D%B4%EB%93%9C.md) 
- [iOS 가이드](./ios%20%EA%B0%80%EC%9D%B4%EB%93%9C.md)
