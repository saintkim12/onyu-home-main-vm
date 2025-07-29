# Firefox Browser

Firefox 브라우저를 Docker 컨테이너로 실행하여 웹 기반 VNC 인터페이스를 통해 접근할 수 있습니다.

## 서비스 정보

- **웹 VNC 인터페이스**: `http://localhost:${FIREFOX_PORT}`
- **기본 포트**: 5800 (환경 변수로 설정 가능)
- **VNC 포트**: 5900 (내부용)

## 시작하기

### 1. 서비스 시작
```bash
docker-compose up -d
```

### 2. 서비스 상태 확인
```bash
docker-compose ps
```

### 3. 로그 확인
```bash
docker-compose logs -f firefox
```

### 4. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `FIREFOX_PORT`: Firefox 웹 VNC 인터페이스 포트 (기본값: 5800)
- `USER_ID`: 컨테이너 내부 사용자 ID (기본값: 1000)
- `GROUP_ID`: 컨테이너 내부 그룹 ID (기본값: 1000)

### 볼륨

- `firefox_data`: Firefox 설정 및 데이터 저장소

### 포트

- `${FIREFOX_PORT}:5800`: 웹 VNC 인터페이스 포트

## 사용법

### 1. 웹 브라우저 접속
브라우저에서 `http://localhost:${FIREFOX_PORT}`에 접속하여 Firefox를 사용할 수 있습니다.

### 2. VNC 클라이언트 접속 (선택사항)
VNC 클라이언트를 사용하여 직접 접속할 수도 있습니다:
- **호스트**: localhost
- **포트**: 5900
- **비밀번호**: 설정되지 않음 (공개)

### 3. 주요 기능

- **완전한 Firefox 브라우저**: 모든 Firefox 기능 사용 가능
- **북마크 및 설정 저장**: 볼륨을 통해 데이터 영속성 보장
- **다운로드**: 파일 다운로드 기능 지원
- **플러그인**: Firefox 확장 프로그램 설치 가능

## 보안 고려사항

1. **VNC 보안**: 기본적으로 VNC는 암호화되지 않으므로, 외부 네트워크에서는 사용하지 마세요.
2. **포트 노출**: 필요한 경우에만 포트를 외부에 노출하세요.
3. **사용자 권한**: USER_ID와 GROUP_ID를 적절히 설정하여 권한 문제를 방지하세요.

## 문제 해결

### 서비스가 시작되지 않는 경우
```bash
# 로그 확인
docker-compose logs firefox

# 포트 충돌 확인
netstat -tulpn | grep :${FIREFOX_PORT}
```

### 화면이 표시되지 않는 경우
1. 브라우저 캐시를 지우고 다시 시도하세요.
2. 다른 브라우저로 접속해보세요.
3. VNC 클라이언트로 직접 접속해보세요.

### 성능 문제
1. 호스트 시스템의 리소스 사용량을 확인하세요.
2. 컨테이너에 충분한 메모리를 할당하세요.
3. 네트워크 대역폭을 확인하세요.

## 고급 설정

### VNC 비밀번호 설정
VNC 비밀번호를 설정하려면 환경 변수를 추가하세요:
```yaml
environment:
  - USER_ID=1000
  - GROUP_ID=1000
  - VNC_PASSWORD=your_password_here
```

### 화면 해상도 설정
화면 해상도를 설정하려면 환경 변수를 추가하세요:
```yaml
environment:
  - USER_ID=1000
  - GROUP_ID=1000
  - DISPLAY_WIDTH=1920
  - DISPLAY_HEIGHT=1080
```

### 자동 시작 URL 설정
Firefox가 시작될 때 특정 URL을 자동으로 열도록 설정:
```yaml
environment:
  - USER_ID=1000
  - GROUP_ID=1000
  - AUTOSTART_URL=https://www.google.com
```

## 참고 자료

- [Firefox Docker Hub](https://hub.docker.com/r/jlesage/firefox)
- [VNC 프로토콜](https://en.wikipedia.org/wiki/Virtual_Network_Computing)
