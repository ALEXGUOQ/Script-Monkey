# Script Monkey

![](https://raw.githubusercontent.com/shinrenpan/Script-Monkey/master/ScriptMonkey/Images.xcassets/AppIcon.appiconset/Icon-76.png)

[Demo video](https://www.youtube.com/watch?v=ic5d5hmPOl4)

Script Monkey 是一款 iPad App, 允許使用者注入自己的 Javascript 到瀏覽器, 類似 firefox 的 Greasemonkey 功能.

> 目前只允許注入單一 Javascript, 理論上是可以注入 N 個.

## Why open source

違反了下列兩項 Review guideline, 雖然我已經把 download feature 拿掉, 甚至寫信給 DTS, 但申訴無效, 所以開源之.

第一條:
> 2.7
>
>We also found that your app downloads code which is not in >compliance with the App Store Review Guidelines.
>
>It would be appropriate to remove this feature from your app or to re->evaluate the concept of your app. 
>
>For app design information, check out the videos: "The Ingredients of >Great Apps" and “Designing User Interfaces for iPhone and iPad Apps,” >available on the iOS Developer Center, and the iOS Human Interface >Guidelines in particular, the sections, "Great iOS Apps Embrace the >Platform and HI Design Principles" and "Human Interface Principles".

第二條:
>PLA 3.3.2
>
>In continuing our review of your app, we found that your app contains >features that are downloaded or streamed to your app. This is not in >compliance with the App Store Review Guidelines.
>
>Specifically, your app allows users to download and use javascript in an >inappropriate manner.
>
>It would be appropriate to remove these features from your app, or make >them native to your app binary to be in compliance with the App Store >Review Guidelines.

## 編譯

ios 8 or later

此 App 使用以下 framework, 編譯前請先下載並設置

[AdMob](http://www.google.com.tw/ads/admob/)

[MBProgressHUD](https://github.com/jdg/MBProgressHUD)

[SRPAlertView](https://github.com/shinrenpan/SRPAlertView)

[SRPLayout](https://github.com/shinrenpan/SRPLayout)

## 問題

### 怎麼匯入 Javascript:

目前可以使用 iTunes file sharing 透過 iTunes 匯入, 或是利用 App 開啟 js 結尾的網站, 利用 Download 按鈕下載, 詳情請看 [Demo video](https://www.youtube.com/watch?v=ic5d5hmPOl4).

### Javascript 沒作用:

請先利用 JSLint or JSHint 檢查 Javascript 是否有問題. 目前網路上的 script 都給一般瀏覽器網頁使用, 你可以到設定頁面切換 User-Agent 至 Safari, 在注入 Javascript, 詳請請看 [Demo video](https://www.youtube.com/watch?v=ic5d5hmPOl4)

### 我是否能把 App 送審上架:

非常歡迎你送審, 如果 Apple 審核通過請來信告知.

### 其他問題請開 Issue

## 贊助

我之後會陸續將無法送審的 App 開源, 如果你想贊助, 可以透過以下方法:

### Paypal:

[![PayPayl donate button](https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=LC58N7VZUST5N "Donate")

### AdMob:

使用我的 AdMob Id:`ca-app-pub-9003896396180654/4692599394`

## License

MIT License
