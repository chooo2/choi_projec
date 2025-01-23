### Simultion Results
![image](https://github.com/user-attachments/assets/02436609-7714-4f33-94c6-b86a3d1c793d)

##### 2025/01/23
BUG analysis 1.

Situation. APB 내에서 데이터를 송수신 타이밍을 컨트롤한다. 이 때, 데이터를 보내지 않기를 원하다가 데이터 stack이 쌓이게 되는 도중에 데이터를 보내고자 한다.

Detail. RX_FIFO.v에서 read enable 신호가 초기에 reset하게 되면 초기값으로 1을 가지게 되어,
무조건 첫번째 값을 read하고, APB내에서 데이터를 송수신하고자하는 타이밍에는 이미 RX FIFO의 read pointer가 1이 증가된
상태에서 시작하게되고, FIFO 내에서 데이터가 계속 Overwrite 되어도 가장 처음 defualt로 read된 값을 초기에 전달하고,
아래 사진처럼 이론상으론 처음 read해야 할 데이터 8'he4값이 read pointer의 영향으로 누락된다.

![image](https://github.com/user-attachments/assets/f8b3fceb-8d04-4d51-9461-8dc620ebc44d)

Tera Term으로 simulation했을 때, 아래와 같은 오류의 규칙성을 확인할 수 있었다.
[1] pselx = 계속 LOW를 유지
1. 11번째 데이터까지는 stable하였다.
2. 이후 보내는 데이터의 오류는 같은 데이터를 보냈을 때와 동일하였다.

[2] pselx = HI에서 특정 횟수에 LO로 변경
1. 첫 번째 데이터가 무시되고 두번째 데이터를 두 번 출력하는 경우를 자주 볼 수 있다.
2. 마찬가지로 보내는 데이터가 동일하면 발생하는 오류도 동일하였다.

![image](https://github.com/user-attachments/assets/3a47050d-2e44-41d5-8c74-c9ed7399ca40)
