# 쿠팡 파트너스 Tag 연동

- **ct_tagid** : 운영팀에서 발행 전달. 
- **ct_div_id** : 광고를 넣을 div id  
ct_div_id를 안 넣거나 빈 문자일경우 body에 넣도록 되어 있음. (빈 iframe 내부에서 코드를 실행할 경우는 ct_div_id를 안 넣으면 됨. )

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