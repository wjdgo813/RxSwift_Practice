Observable
==========
> 사전적 의미 : 관찰 가능한, 관찰할수 있는<br/>
> ReactiveX에서 옵저버는 Observable을 구독한다. Obseravable이 배출하는 하나 또는 연속된 항목에 옵저버는 반응한다. 이러한 패턴은 동시성 연산을 가능하게 한다. 그 이유는 Observable이 객체를 배출할 때까지 기다릴 필요 없이 어떤 객체가 배출되면 그 시점을 감시하는 관찰자를 옵저버 안에 두고 그 관찰자를 통해 배출 알림을 받으면 되기 때문이다.<br/>
> Link: [ReactiveX](http://reactivex.io/documentation/ko/observable.html)

* onNext()

  observable은 새로운 항목들을 배출할 때 마다 이 메서드를 호출한다. 이 메서드는 Observable이 배출하는 항목을 파라미터로 전달받는다.

* onError

  Observalble은 데이터가 생성되지 않았거나 에러가 발생 했을 때, 오류를 알리기 위해 이 메서드를 호출한다.

  이 메서드가 호출되면 onNext()나 onComplete()는 더 이상 호출되지 않는다.

* onComplete 

  오류가 끝까지 발생하지 않았다면 마지막 onNext()를 호출한 후 이 메서드를 호출한다.





  https://pilgwon.github.io/blog/2018/04/29/RxSwift-Getting-Started.html#observables-aka-sequences
