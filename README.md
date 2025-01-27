# Read me

### Title

#### 1-1. UART
기본적인 UART Protocol을 구현한 것으로, Rx, Tx module을 통해 서로 데이터를 송수신 하는 과정을 증명할 수 있습니다.

#### 1-2. UART + ALU
1-1. 에서 구현한 UART module을 바탕으로 Baudarate를 맞추어, Tera term에서 수식을 입력하면
결과값을 계산하여 출력하도록 하였으며, 데이터 전/후 처리와 ALU Logic을 삽입하였습니다.

#### 1-3. UART + APB
지금껏 구현된 UART module을 바탕으로 APB Bridge와 연결하여, 데이터를 송수신하고 MASTER를 통해서 UART Command를 날려주어,
데이터를 다룰 수 있도록 구현되었습니다.

#### 2. V snyc
