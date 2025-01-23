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
