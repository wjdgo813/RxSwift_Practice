Observable
==========

> 사전적 의미 : 관찰 가능한, 관찰할수 있는<br/>
> ReactiveX에서 옵저버는 Observable을 구독한다. Obseravable이 배출하는 하나 또는 연속된 항목에 옵저버는 반응한다. 이러한 패턴은 동시성 연산을 가능하게 한다. 그 이유는 Observable이 객체를 배출할 때까지 기다릴 필요 없이 어떤 객체가 배출되면 그 시점을 감시하는 관찰자를 옵저버 안에 두고 그 관찰자를 통해 배출 알림을 받으면 되기 때문이다.<br/>
> Link: [ReactiveX](http://reactivex.io/documentation/ko/observable.html)



* * *



### 기초

*  Observable

  Rx에서는 "옵저버"에 의해 임의의 순서에 따라 병렬로 실행되고, 결과는 나중에 연산된다. 즉, 메서드 호출보다도 "Observable"안에 데이터를 조회하고 반환하는 매커니즘을 정의한 후, Observable이 이벤트를 발생시키면 옵저버의 관찰자가 그 순간을 감지하고 준비된 연산을 실행시켜 결과를 리턴하는 메카니즘으로 인해 Observable을 구독한다고 표현하는 것이 올바르다.

-----------------

<br/>

### Hot Observable and Cold Observable

- Hot Observable

  옵저버가 subscribe 되는 시점부터 이벤트를 생성하여 방출하기 시작한다.

  기본적으로 Hot Observable로 생성하지 않은 것들을 Cold Observable 이라고 이해하면 된다.
  

- Cold Observable

  생성과 동시에 이벤트를 방출하기 시작한다. 또, 이후 subscribe 되는 시점과 상관없이 옵저버들에게 이벤트를 중간부터 전송한다.

  Rx에서는 다른마로, connectable Observable이라고 한다.

  ~~~
  예시)
  아프리카TV의 실시간 방송 : Hot Observable 
  -> 시청자(observer)가 어느 시점에 방송을 시청하던, 상관없이 방송이 진행되고 시청자는 방송을 시청(subscribe)하는 시점부터 방송을 볼 수 있다.
  
  아프리카TV의 VOD : Cold Observable 
  -> 어떤 시청자(observer)든 시청을 시작(subscribe)하면 처음부터 방송이 시작된다. (emit 1,2,3....)
  ~~~




### 옵저버 생성  

~~~
1. 비동기 메소드 호출로 결과를 리턴받고 필요한 동작을 처리하는 메서드를 정의한다. (옵저버의 일부가 될 메서드)
2. Observable로 비동기 호출을 정의한다.
3. 구독을 통해 옵저버를 Observable 객체에 연결 시킨다. 
4. 필요한 코드를 계속 구현한다. 메서드 호출로 결과가 리턴 될 때마다. 연산을 시작한다.

//옵저버의 onNext 핸들러를 정의한다.
def myOnNext = { it ->  /* 필요한 연산을 처리 */}

//Observable을 정의한다.
def myObservable = someObservable(itsParameters)

//옵저버가 Observable을 구독한다.
myObservable.subscribe(myOnNext)
~~~



- onNext()

  observable은 새로운 항목들을 배출할 때 마다 이 메서드를 호출한다. 이 메서드는 Observable이 배출하는 항목을 파라미터로 전달받는다.

- onError

  Observalble은 데이터가 생성되지 않았거나 에러가 발생 했을 때, 오류를 알리기 위해 이 메서드를 호출한다.

  이 메서드가 호출되면 onNext()나 onComplete()는 더 이상 호출되지 않는다.

- onComplete 

  오류가 끝까지 발생하지 않았다면 마지막 onNext()를 호출한 후 이 메서드를 호출한다.

  [참고 블로그](https://pilgwon.github.io/blog/2018/04/29/RxSwift-Getting-Started.html#observables-aka-sequences)	



--------

Disposing
======

> 현재 구독 중인 Observable 중, 옵저버가 더 이상 구독을 원하지 않는 경우에는 이 메서드를 호출해서 구독을 해지할 수 있다.
> Subscribe 메서드는 Disposable 인스턴스를 리턴한다. Observable의 사용이 끝나면 메모리를 해제해야 하는데, 그 때 사용할 수 있는 것이 Dispose이다.
>
> RxSwift에서는 DisposeBag을 사용하는데 DisposeBag instance의 deinit()이 실행 될 때 모든 메모리를 해제한다. 이 DisposeBag에 subscribe가 리턴하는 Disposable 인스턴스를 넣어주기만 하면 된다.

링크 : [pilgwon 블로그](https://pilgwon.github.io/blog/2018/04/29/RxSwift-Getting-Started.html#observables-aka-sequences)

~~~swift
var disposeBag     = DisposeBag()
let stringSequence = Observable.just("RxSwift Observable")
let subscription   = stringSequence.subscribe{ (event) in
	print(event)    
}

subscription.disposed(by: disposeBag) //subscription을 disposeBag에 넣어 메모리를 직접 해제
disposeBag = DisposeBag() // 빠르게 비워주고 싶을때는 disposeBag을 새로 만들면 됩니다.

/*
subscription.dispose()처럼 직접 호출 할 수 있습니다. 하지만 직접 호출하는 것은 bad code smell입니다.
Thread가 다를 때 Observable을 사용하기도 전에 메모리를 비워주는 일이 발생할 수 있기 때문입니다.
일반적으로는 DisposeBag, takeUntil 연산자 또는 다른 매커니즘과 같이 구독을 dispose하는 방법들이 많이 있습니다.
*/

~~~

<br/>

### Dispose Bags

DisposeBag은 Rx에서 ARC와 비슷한 역할을 합니다.
DisposeBag이 해제 됐을 때, 추가된 disposables들 모두에게 dispose를 호출합니다. 그 자체에는 dispose()가 없어서 다른 목적으로 예외적인 호출은 불가능합니다. 즉각적인 정리가 필요하면 새로운 가방을 만들면 됩니다.

~~~Swift
self.disposeBag = DisposeBag()
~~~

위의 코드는 오래된 참조들을 정리해주고 자원들이 해제되도록 합니다.

만약 예외적인 수동의 해제가 필요하다면, CompositeDisposable을 사용해보십시오. CompositeDisposable은 원하는 기능을 가지고 있을 것이지만 dispose가 호출 됐을 때 새롭게 추가된 disposable도 즉시 해제시켜 버립니다.<br/>



### Take until

dealloc시에 구독을 자동으로 해제하는 또 다른 방법은 takeUntil 연산자입니다.

~~~swift
sequence
	.takeUntil(self.rx.deallocated)
	.subscribe {
        print($0)
	}
~~~



### 나만의 옵저버블 만들기(aka 옵저버블 시퀀스)

- 옵저버블이 만들어지면, 그것은 만들어졌을 뿐이기 때문에 아무일도 하지 않습니다.

만약 여러분이 그저 옵저버블을 반환하는 메소드를 호출했다면, 시퀀스 생성은 일어나지 않을 것이고 부작용도 없을 것입니다. 옵저버블은 그저 시퀀스가 어떻게 만들어지고 요소 생성에 어떤 파라미터가 필요한지에 대해 적혀있을 뿐입니다. 시퀀스 생성은 subscribe 메소드가 호출됐을 때 시작됩니다.

~~~swift
func searchWikipedia(searchTerm : String) -> Observable<Result>{}

let searchForMe = searchWikipedia("me") 
//아무 리퀘스트도 실행되지 않으며, 어떤 작업도 작동하지 않습니다.

let cancel = searchForMe //여기서 시퀀스 생성이 시작되고, URL 리퀘스트들이 발생합니다.
	.subscribe(onNext:{ results in
    	print(results)
	})

~~~

<br/>

- create

자신의 옵저버블 시퀀스를 만드는 방법은 아주 많습니다. 그 중에서 create함수 입니다.
구독을 하면 하나의 요소를 반환하는 시퀀스를 만드는 함수인 just를 만들어봅시다.

~~~swift
//하나의 요소를 반환하는 Observable
func myJust<E>(_ element: E) -> Observable<E>{
    return Observable.create { observer in
       observer.on(.next(element))
	   observer.on(.completed)
       return Disposables.create()
    }
}

myJust(0).subscribe(onNext:{n in
	print(n)    
	})

/*
결과 : 0
*/

~~~



배열의 요소를 반환하는 from

~~~swift
//배열의 요소를 반환하는 Observable
func myFrom<E>(_ sequence: [E]) -> Observable<E>{
    return Observable.create { observer in
                              for element in sequence{
                                  observer.on(.next(element))
                              }
                 			  observer.on(.completed)
                              return Disposables.create()
    }
}

let stringCounter = myFrom(["first","second"])

print("Started ----")

//첫 시도
stringCounter
.subscribe(onNext:{ n in
    print(n)
})

print("----")

stringCounter
.subscribe(onNext:{ n in
                   print(n)
})

print("Ended ----")
~~~

<br/>

- 작동하는 Observable 만들기

  - interval 연산자 만들기

  ~~~swift
  func myInterval(_ interval: TimeInterval) -> Observable<Int>{
      return Observable.create{ observer in
      	print("Subscribed")
         	let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
  		timer.scheduleRepeating(deadline: DispatchTime.now() + interval, interval: interval)
  		
  		let cancel = Disposables.create{
          	print("Disposed")                         
              timer.cancel()
  		}
                               
  		var next = 0
  		timer.setEventHandler{
              if cancel.isDisposed{
                  return
              }
              observer.on(.next(next))
              next += 1
  		}
  		timer.resume()
          return cancel
      }
  }
  ~~~

  ~~~swift
  let counter = myInterval(0.1)
  print("started!!")
  
  let subscribtion = counter
  .subscribe(onNext:{ n in
      print(n)
  })
  
  Thread.sleep(forTimeInterval: 0.5)
  subscription.dispose()
  
  /*
  Started ----
  Subscribed
  0
  1
  2
  3
  4
  Disposed
  Ended ----
  */
  ~~~

  - 개별 요소들의 시퀀스

    ~~~swift
    let counter = myInterval(0.1)
    
    print("Started ---")
    
    let subscription1 = count 
    .subscribe(onNext:{ n in
        print("First \(n)")
    })
    
    let subscription2 = count
    .subscribe(onNext:{ n in
        print("Second \(n)")
    })
    
    Thread.sleep(forTimeInterval:0.5)
    subscription1.dispose()
    Thread.sleep(forTimeInterval:0.5)
    subscription2.dispose()
    
    print("Ended----")
    /*
    Started ----
    Subscribed
    Subscribed
    First 0
    Second 0
    First 1
    Second 1
    First 2
    Second 2
    First 3
    Second 3
    First 4
    Second 4
    Disposed
    Second 5
    Second 6
    Second 7
    Second 8
    Second 9
    Disposed
    Ended ----
    */
    ~~~

    - 구독 공유와 sharedReplay 연산자

    ~~~swift
    let counter = myInterval(0.1)
    	.shareReplay(1)
    print("Started ---")
    
    let subscription1 = counter
    .subscribe(onNext:{ n in
        print("First \(n)")
    })
    let subscription2 = counter
    .subscribe(onNext:{ n in
    	print("Second \(n)")
    })
    
    Thread.sleep(forTimeInterval:0.5)
    subscription1.dispose()
    Thread.sleep(forTimeInterval:0.5)
    subscription2.dispose()
    
    print("Ended ----")
    
    /*
    Started ----
    Subscribed
    First 0
    Second 0
    First 1
    Second 1
    First 2
    Second 2
    First 3
    Second 3
    First 4
    Second 4
    First 5
    Second 5
    Second 6
    Second 7
    Second 8
    Second 9
    Disposed
    Ended ----
    */
    ~~~

  - Sharing subscription and share operator

    ~~~swift
    let counter = myInterval(0.1)
        .share(replay: 1)
    
    print("Started ----")
    
    let subscription1 = counter
        .subscribe(onNext: { n in
            print("First \(n)")
        })
    let subscription2 = counter
        .subscribe(onNext: { n in
            print("Second \(n)")
        })
    
    Thread.sleep(forTimeInterval: 0.5)
    subscription1.dispose()
    Thread.sleep(forTimeInterval: 0.5)
    subscription2.dispose()
    
    print("Ended ----")
    
    /*
    Started ----
    Subscribed
    First 0
    Second 0
    First 1
    Second 1
    First 2
    Second 2
    First 3
    Second 3
    First 4
    Second 4
    First 5
    Second 5
    Second 6
    Second 7
    Second 8
    Second 9
    Disposed
    Ended ----
    */
    ~~~

  - HTTP Request Rx Example

    ~~~swift
    extension Reactive where Base: URLSession{
        public func response(request:URLRequest) -> Observable<(response:HTTPURLResponse, data:Data)>{
            return Observable.create{ observer in
    			let task = self.dataTaskWithRequest(request) { (data,response,error) in
    				guard let response = response, let data = data else {
    					observer.on(.error(error ?? RxCocoaURLError.Unknwon))
                        return
                    }                     
    			}
                
    				guard let httpResponse = response as? HTTPURLResponse else{
    					observer.on(.error(RxCocoaURLError.nonHTTPResponse(response:response)))
                        return
    				}
    				observer.on(.next(httpResponse, data))
    				observer.on(.completed)
            }
            task.resume()
            
            return Disposables.create{
                task.cancel()
            }
        }
    }
    ~~~







