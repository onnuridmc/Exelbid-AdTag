# 관여 프로젝트

## 자바스크립트
- http://src.onnuridmc.com/system/JavaScriptsProject.git
- /adtag/js/ctads.org.js
- 아래 코드 주석을 반드시 풀어서 배포.

~~~ javascript
crosstarget_tag.crosstarget_base_url = '//ct-adn.exelbid.com/c_partner/';
~~~


배포시
https://jscompress.com
에서 압축후 아래의 명령어로 배포할것.
~~~ bash
aws s3 cp release/st2/js/ctads.js s3://onnuridmc-banner/st2/js/ctads.js  --cache-control max-age=600 --content-type application/javascript
~~~

## php 
- http://src.onnuridmc.com/system/internal-api.git
- select_adn_web_taginfo_all() 함수만 체크하면 됨. 태그정보를 엔진에서 가져옴.

## 엔진
- http://src.onnuridmc.com/crosstarget/adnetworkengine.git
-   엔진설명은 손팀장님께 다 전달함.

## 준비사항
- DB 설명
~~~
테이블 : al.adn_web_taginfo
  `channel_id` : 알수 있는 매체명 설명으로 사용.
  `pub_idx` : 매체 하나와 묶어둠 당분간 고정으로 사용. 상용 : 158
  `width` : 지면 사이즈
  `height` : 지면 사이즈
  `tagid` : 태그아이디.  스크립트에서 tagid 가 맞지 않으면 사용 불가능.
  `subid` : 서브아이디 (현재 사용안함.)
  `iframe_url` : 전달할 iframe_url
  `click_url` : 전달할 click_url
  `shop_idx` : 캠페인 하나와 묶어둠 (현재 사용안함).
  `campaign_g_idx` : 캠페인 하나와 묶어둠 (현재 사용안함).
  `campaign_idx` : 캠페인 하나와 묶어둠 (현재 사용안함).
  `ads_idx` : 캠페인 하나와 묶어둠 (현재 사용안함).
~~~
- DB 입력문 샘플
~~~ sql
INSERT INTO `al`.`adn_web_taginfo`
(
`channel_id`,
`pub_idx`,
`width`,
`height`,
`tagid`,
`subid`,
`iframe_url`,
`click_url`,
`shop_idx`,
`campaign_g_idx`,
`campaign_idx`,
`ads_idx`,
`status_flag`)
VALUES
(
'a100',
158,
320,
480,
'adn38708_a100_320x480',
'adn38708',
"https://ct-dad.exelbid.com/coupang?width=320&height=480&subid=adn38708&r={{ item['click_encode'] }}",
"https://www.coupang.com?gaid={GAID}&idfa={IDFA}&click_id={clk_id}",
1499,
11362,
38708,
418361,
'Y'
);
~~~
- 쿠팡파트너스 id에 width x height 를 tagid로 사용함. 안 맞아도 상관없음.
- 'adn38708' 의 경우 adn + 캠페인 번호임.
- ifrmae_url 과 click_url 을 틀리지 않게 조심해서 넣어야 함. 


## 자비스크립트 샘플
~~~ javascript
!function (w,d,s,u,t,ss,fs) {
    if(w.crosstarget_tag)return;t=w.crosstarget_tag={};if(!window.t) window.t = t;
    t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
    t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
    fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
}(window,document,'script','//st2.exelbid.com/js/ctads.js');
var ct_tagid = 'adn38708_a100_300x250'
var ct_div_id = 'div-ct-crosstarget'
crosstarget_tag.push(function () {
    crosstarget_tag.initAdBanner(ct_tagid, 320, 250, ct_div_id)
    .setResponseCallback(function (result){ 
        if(result.status == 'OK'){
            //TODO  광고 처리 됨
        }else{
            // 광고 없음. passback 처리.
        }
    });
});

crosstarget_tag.push(function () {
    crosstarget_tag.loadAd(ct_tagid);
});
~~~
- ct_tagid : 이미 할당된것을 전달 줘야 합니다.  
- tagid는 미리 만들어둠. 'adn38708_a100_320x50', 'adn38708_a100_300x250', 'adn38708_a100_320x480'
- ct_div_id : 광고를 넣을 div id 
- ct_div_id 가 안 넣거나 빈 문자일경우 body에 넣도록 되어 있음. (빈 iframe 내부에서 코드를 실행할 경우는 ct_div_id를 안 넣으면 됨. )

### 쿠팡 파트너스 추천 스크립트
~~~ javascript
var isAndroid = /Android/.test(navigator.userAgent) ? true :  false;
if(isAndroid){
    !function (w,d,s,u,t,ss,fs) {
        if(w.crosstarget_tag)return;t=w.crosstarget_tag={};if(!window.t) window.t = t;
        t.push = function() {t.callFunc?t.callFunc.apply(t,arguments) : t.cmd.push(arguments);};
        t.cmd=[];ss = document.createElement(s);ss.async=!0;ss.src=u;
        fs=d.getElementsByTagName(s)[0];fs.parentNode.insertBefore(ss,fs);
    }(window,document,'script','//st2.exelbid.com/js/ctads.js');
    var ct_tagid = 'adn38708_a100_300x250'
    var ct_div_id = 'div-ct-crosstarget'
    crosstarget_tag.push(function () {
        crosstarget_tag.initAdBanner(ct_tagid, 320, 250, ct_div_id)
        .setResponseCallback(function (result){ 
            if(result.status == 'OK'){
                //TODO  광고 처리 됨
            }else{
                // 광고 없음. passback 처리.
            }
        });
    });

    crosstarget_tag.push(function () {
        crosstarget_tag.loadAd(ct_tagid);
    });
}
~~~