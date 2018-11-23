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

  ![async_subject](./picture/filter.png)

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








