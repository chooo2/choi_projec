현재 단계는 UART 송수신을 APB Bridge를 거쳐 잘 전달되는 것을 확인하는 것이라
APB 상단의 MASTER와 통신하기 위한 부분을 다시 고려해주어야한다.
그리고 APB_SLAVEx.v에 수정 사항이 더 있는데, meemory에 데이터를 할당하는 부분에서
always 문이 중복되었으니, 하나로 합쳐야합니다.

### Simulation Results
![image](https://github.com/user-attachments/assets/8ed9da72-ae76-443c-a157-eb3d71073da0)

## 추가 test(baud level)
### Elabrated Desgin
![image](https://github.com/user-attachments/assets/93ae478f-7e5d-469b-b3cf-fdce98f85b8e)

### Synthesis
![image](https://github.com/user-attachments/assets/7e8571cf-d3ae-4505-9994-5e880abf56fc)

### Result in Teraterm
![image](https://github.com/user-attachments/assets/ba0449ae-6d17-4137-a312-1ba2cffda425)
TX data가 깨지는 것을 볼 수 있는데 해당 부분을 다시 검토해봐야겠습니다.
