Subject
======

<br/>

> Rx에는 Hot Observable과 Cold Observable의 개념이 있는데, Subject는 Cold Observable을 Hot하게 변형하는 효과를 얻을 수 있다.
>
> Subject는 Imperactive eventing으로 어떤 이벤트를 발생하고 싶을 때, 얼마나 많은 객체에게 그 이벤트를 구독하는지는 중요하지 않다. 원하는 이벤트를 subscription(observer) 존재 여부와 관계 없이 이벤트를 발행 할 수 있다.

<br/>

-------------------------

<br/>

## 4가지 종류의 subject

### AsyncSubject

complete 될때까지 이벤트는 발생되지 않으며 complete가 되면 마지막 이벤트를 발생하고 종료된다.

![async_subject](./picture/AsyncSubject1.png)

만약 에러로 종료되면 마지막 이벤트 전달 없이 에러가 발생된다.

![async_subject](./picture/AsyncSubject2.png)

~~~swift
let asyncSubject = AsyncSubject<String>()
asyncSubject.debug().subscribe{
    print($0)
}.disposed(by:disposeBag)

asyncSubject.on(.next("1"))
asyncSubject.on(.next("2"))
asyncSubject.on(.next("3"))
asyncSubject.on(.completed)

/*
결과 
//asyncSubject()->subscribed
//asyncSubject()->Event next(3)
next(3)
//asyncSubject()->Event completed
completed
//asyncSubject()->isDisposed
*/
~~~

<br/>

### PublishSubject

PublishSubject는 subscribe 된 시점 이후부터 발생한 이벤트를 전달한다. subscribe 되기 이전의 이벤트는 전달하지 않는다.

![async_subject](./picture/publishSubject.png)

에러가 발생하면 마찬가지로 에러를 전달한다.

![async_subject](./picture/publishSubjectError.png)

~~~swift
let publishSubject = PublishSubject<String>()
publishSubject.debug().subscribe{
    print("first subscribe:\($0)")
}.disposed(by:disposeBag)

publishSubject.on(.next("1"))
publishSubject.on(.next("2"))
publishSubject.debug().subscribe{
    print("second subscribe:\($0)")
}.disposed(by:disposeBag)
publishSubject.on(.next("3"))
publishSubject.on(.completed)

/** 
결과
//publishSubject()->subsribed
//publishSubject()->Event next(1)
first subscribe: next(1)
//publishSubject()->Event next(2)
first subscribe: next(2)
//publishSubject()->subscribed
//publishSubject()->Event next(3)
first subscribe: next(3)
second subscribe: next(3)
//publishSubject()->Event completed
first subscribe: completed
//publishSubject()->isDisposed
//publishSubject()->Event completed
second subscribe: completed
//publishSubject()->isDisposed
*/
~~~

<br/>

### BehaviorSubject

