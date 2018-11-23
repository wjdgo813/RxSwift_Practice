Operator
=======

## Filtering Operator

- Ignoring Operators

  모든 .next event를 무시한다. 다만 종료 event는 전달한다 (.error, .complete) 시퀀스가 종료되는 시점만 알 수 있다.

  ![async_subject](./picture/ignoringOperator.png)

  1,2,3의 이벤트가 발생하고 있다. 하지만 모든 이벤트들이 ignoreElement()에 걸려서 통과하고 있지 못한다. 결국 subscribe하고 있는 아래 라인에서는 어떤 이벤트도 받지 못하다가 마지막 종료 이벤트만 전달되고 있음을 알 수 있다.

  ~~~swift
  let strikes = PublishSubject<String>()
  let disposeBag = DisposeBag()
  
  strikes.ignoreElements().subscribe({ (_) in
  	print("You're out!")    
  }).disposed(by:disposeBag)
  
  strikes.onNext("X")
  strikes.onNext("X")
  strikes.onNext("X")
  strikes.onCompleted()
  
  /*
  결과
  you're out!
  //종료 이벤트 1번만 전달 됨.
  */
  ~~~

<br/>

- Element At

  "Observable에서 발생하는 이벤트 중 n번째 이벤트만 받고 싶다."  이럴 경우에 사용한다.

  ![async_subject](./picture/elementAt.png)

  1,2,3의 이벤트가 발생하지만 모든 이벤트를 subscribe하고 싶지가 않다. 1인덱스에 발생하는 이벤트만 subscribe하고 싶다 -> elementAt(1)

  ~~~swift
  let strikes = PublishSubject<String>()
  let disposeBag = DisposeBag()
  
  strikes.elementAt(2)
  .subscribe(onNext:{ _ in
      print("You're out!")
  }).disposed(by:disposeBag)
  
  strikes.onNext("Z")
  strikes.onNext("X")
  strikes.onNext("Y")
  
  /*
  You're out! //"Y"(2번쨰 인덱스)의 이벤트 전달 
  */
  ~~~

<br/>

- Filter

  filter는 Bool을 리턴하는 클로저를 받아서 모든 Observable Event를 검사한다. 클로져를 true로 만족시키는 event만 filter를 통과하게 된다. 

  ![async_subject](./picture/Filter.png)

  1,2,3의 이벤트가 발생하고 있지만 이 시퀀스에 { $0 < 3 } 이라는 필터를 걸었다. 그래서 1,2의 이벤트만 전달되었다.

  ~~~swift
  example(of:"filter") {
  	let disposeBag  = DisposeBag()
      Observable.of(1,2,3,4,5,6)
      .filter{ integer in
          integer % 2 == 0
  	}.subscribe(onNext:{
          print($0)
      }).disposed(by:disposeBag)
  }
  
  /*
  결과 
  2
  4
  6
  */
  ~~~

<br/>

- Skipping operators

  1. skip(_:)

     시퀀스에 skip operator가 전달되면, 처음에 발생하는 n개의 이벤트를 무시할 수 있다.

     ![skip](./picture/skip.png)

     위의 그림처럼 처음 발생한 2개의 이벤트. 즉 1,2가 무시되고 3만 전달된다.

     ~~~swift
     let disposeBag = DisposeBag()
     observable.of("A","B","C","D","E","F")
     	.skip(3)
     .subscribe(onNext:{
         print($0)
     }).disposed(by:disposeBag)
     
     /* 결과
     D
     E
     F
     */
     ~~~

     <br/>

  2. skipWhile(_:)

     skipWhile은 filter의 기능과 유사하다.

     - filter는 검사를 통과하는 element만 전달한다.
     - skipWhile은 검사를 통과하지 못한 element를 전달한다.

     ![skipWhile](./picture/skipWhile.png)

     1을 대입한 클로져는 true를 리턴한다. 1은 skip되어 전달되지 못한다.

     2을 대입한 클로져는 false를 리턴하기 때문에, skip하지 않고 전달된다.

     이후 이벤트는 클로져 검사와 관계 없이 모두 전달 된다.

     ~~~swift
     Observable.of(2,2,3,4,4)
     .skipWhile({ineger in
         integer % 2 ==0
     }
     .subscribe(onNext:{
     	print($0)               
     })
     /*결과
     3
     4
     4
     */
     ~~~

     <br/>

  3. skipUntil(_:)

     ![skipUntil](./picture/skipUntil.png)

     데이터 시퀀스에서 1,2,3이 발생되고 있다.

     하지만 Trigger의  .next 이벤트(보라색 동그라미)가 발생할 때까지는 skip이 되고있다. 

     그 결과, 보라색 이벤트가 발생하기 전의 모든 이벤트가 무시된다.

     ~~~swift
     let disposeBag = DisposeBag()
     
     let subject = PublishSubject<String>()
     let trigger = PublishSubject<String>()
     
     subject
     	.skipUntil(trigger)
     	.subscribe(onNext:{
         print($0)
     })
     .disposed(by:disposeBag)
     
     subject.onNext("A")
     subject.onNext("B")
     trigger.onNext("X") //트리거의 next가 호출된 이후부터 subject에서 이벤트가 전달 된다.
     subject.onNext("C")
     
     /* 결과
     C
     */
     ~~~

  <br/>

- Taking operators

  1. take( _: )
     take은 skip의 정반대 개념이다.  skip은 처음 발생하는 n개의 이벤트를 무시하는 기능이었다면, take는 처음 발생하는 n개의 이벤트만 받고 나머지는 무시한다.
  2. 







