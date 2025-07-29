# DuckDNS

DuckDNS는 무료 동적 DNS 서비스로, 고정 IP가 없는 환경에서 도메인을 통해 서버에 접근할 수 있게 해줍니다.

## 서비스 정보

- **서비스 유형**: 동적 DNS 업데이트
- **업데이트 주기**: 자동 (컨테이너 재시작 시)

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
docker-compose logs -f duckdns
```

### 4. 서비스 중지
```bash
docker-compose down
```

## 설정

### 환경 변수

- `DUCKDNS_DOMAIN`: DuckDNS 서브도메인 (예: mydomain)
- `DUCKDNS_TOKEN`: DuckDNS API 토큰

### 설정 방법

1. **DuckDNS 계정 생성**
   - [DuckDNS 웹사이트](https://www.duckdns.org/)에서 계정을 생성합니다.

2. **도메인 생성**
   - 원하는 서브도메인을 생성합니다 (예: mydomain.duckdns.org).

3. **토큰 확인**
   - 계정 페이지에서 API 토큰을 확인합니다.

4. **환경 변수 설정**
   ```bash
   export DUCKDNS_DOMAIN=mydomain
   export DUCKDNS_TOKEN=your_duckdns_token_here
   ```

## 사용법

### 1. 도메인 확인
설정이 완료되면 `http://yourdomain.duckdns.org`로 서버에 접근할 수 있습니다.

### 2. 로그 확인
```bash
# DNS 업데이트 상태 확인
docker-compose logs duckdns
```

### 3. 수동 업데이트
필요한 경우 수동으로 DNS를 업데이트할 수 있습니다:
```bash
curl "https://www.duckdns.org/update?domains=yourdomain&token=your_token&ip="
```

## 보안 고려사항

1. **토큰 보안**: DuckDNS 토큰을 안전하게 보관하세요.
2. **환경 변수**: 토큰을 환경 변수 파일에 저장할 때 파일 권한을 제한하세요.
3. **네트워크 보안**: 외부 접근이 필요한 서비스에만 포트를 열어두세요.

## 문제 해결

### DNS 업데이트가 되지 않는 경우
```bash
# 로그 확인
docker-compose logs duckdns

# 수동 업데이트 테스트
curl "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip="
```

### 토큰이 유효하지 않은 경우
1. DuckDNS 웹사이트에서 토큰을 다시 확인하세요.
2. 환경 변수가 올바르게 설정되었는지 확인하세요.

### 도메인이 작동하지 않는 경우
1. DNS 전파 시간을 기다리세요 (최대 24시간).
2. `nslookup yourdomain.duckdns.org`로 DNS 확인을 해보세요.

## 고급 설정

### 자동 업데이트 주기 설정
더 자주 업데이트하려면 cron 작업을 추가할 수 있습니다:
```bash
# crontab 편집
crontab -e

# 5분마다 업데이트
*/5 * * * * curl "https://www.duckdns.org/update?domains=yourdomain&token=your_token&ip="
```

## 참고 자료

- [DuckDNS 공식 웹사이트](https://www.duckdns.org/)
- [DuckDNS Docker Hub](https://hub.docker.com/r/linuxserver/duckdns)
