Subject
======

<br/>

> Rx에는 Hot Observable과 Cold Observable의 개념이 있는데, Subject는 Cold Observable을 Hot하게 변형하는 효과를 얻을 수 있다.
>
> Subject는 Imperactive eventing으로 어떤 이벤트를 발생하고 싶을 때, 얼마나 많은 객체에게 그 이벤트를 구독하는지는 중요하지 않다. 원하는 이벤트를 subscription(observer) 존재 여부와 관계 없이 이벤트를 발행 할 수 있다.

<br/>

-------------------------

## 4가지 종류의 subject

<br/>

### AsyncSubject

complete 될때까지 이벤트는 발생되지 않으며 complete가 되면 마지막 이벤트를 발생하고 종료된다.



