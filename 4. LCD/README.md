## Determine Video signal processing
이번 HW는 영상 신호 처리에 사용되는 V sync와 H sync로, 
화면에 출력할 때, Sync를 맞추어주는 것으로,
각각 Vertical Synchronize, Horizontal Synchronize입니다.
이번에 구현된 HW는 매우 간단한 기초적인 수준으로 구현되었습니다.

Hsync는 Front : Active : Bacl = 2 : 5 : 2
Vsync는 Front : Acitve : Back = 3 : 10 : 3 의 비를 가지도록 구현되었습니다.

## Block Diagram
![image](https://github.com/user-attachments/assets/f47aa167-d2bb-4b8b-bc3c-c4d5c750f2b8)
위 사진에서 중앙의 Activation 영역이 실제 영상이 출력되는 구간으로, V sync와 H sync 모두 Acivation 상태에서 출력됩니다.

## Simulaiton Waveform
![image](https://github.com/user-attachments/assets/5f526660-64b8-4730-88e0-677c78ea92dc)
위 Simulation Waveform을 보면, 1 Row의 Frame 출력되고 있음을 알 수 있습니다.
