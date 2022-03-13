# swap-image
NTUST Computer Vision and Applications
![](https://github.com/naiyu0609/swap-image/blob/main/png/1.PNG)

![](https://github.com/naiyu0609/swap-image/blob/main/png/2.PNG)
在解出H矩陣後，利用圖像座標去解出對應座標，可以發現其實會有一個對應座標對應到不同圖像座標點的情形發生(上圖紅框，並未全部標出)，如果使用這個方式對應過去圖像，會發生最後一個圖像點就會蓋住前面的前面值，也不能保證圖像會完全無空洞情形發生。因此我成像所利用的方式是相反的概念，上表是左圖座標點對應到右圖座標點，我並不會利用此表去做左圖影像交換到右圖的方式，因為會發生我上述所說的情況。我反而是利用這張表去將右圖影像交換到左圖，這樣才會是一對一的情形，雖然說可能會重複複製pixel值，但此種情形並不會發生重複覆蓋或是空洞的情況發生。
![](https://github.com/naiyu0609/swap-image/blob/main/png/3.PNG)
