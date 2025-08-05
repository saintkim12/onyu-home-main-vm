# AdGuard Home

AdGuard Home은 네트워크 전체를 위한 광고 및 트래킹 차단 DNS 서버입니다.

## 서비스 정보

- **웹 관리 인터페이스**: `http://localhost:${ADGUARD_PORT_HTTP}`
- **HTTPS 관리 인터페이스**: `https://localhost:${ADGUARD_PORT_HTTPS}`
- **DNS 서버**: `localhost:${ADGUARD_PORT_DNS}`
- **DNS-over-TLS**: `localhost:${ADGUARD_PORT_DNS_OVER_TLS}`
- **DNS-over-HTTPS**: `localhost:${ADGUARD_PORT_DNS_OVER_HTTPS}`

## 시작하기

### 1. 환경 변수 설정
AdGuard Home을 시작하기 전에 환경 변수 파일을 설정해야 합니다:

<!-- ```bash
# .env 파일 생성
cp env.example .env
``` -->

필수 환경 변수:
- `ADGUARD_PORT_HTTP`: 웹 관리 인터페이스 포트 (기본값: 3000)
- `ADGUARD_PORT_HTTPS`: HTTPS 관리 인터페이스 포트 (기본값: 3001)
- `ADGUARD_PORT_DNS`: DNS 서버 포트 (기본값: 53)
- `ADGUARD_PORT_DNS_TCP`: DNS 서버 TCP 포트 (기본값: 53)
- `ADGUARD_PORT_DNS_OVER_TLS`: DNS-over-TLS 포트 (기본값: 853)
- `ADGUARD_PORT_DNS_OVER_HTTPS`: DNS-over-HTTPS 포트 (기본값: 443)
- `TZ`: 시간대 설정 (기본값: Asia/Seoul)

### 2. 서비스 시작
```bash
docker-compose up -d
```

### 3. 초기 설정
1. 웹 브라우저에서 `http://localhost:${ADGUARD_PORT_HTTP}`에 접속
2. "Get Started" 클릭
3. 관리자 계정 생성 (사용자명, 비밀번호)
4. 웹 인터페이스 포트 설정 (기본값: 3000)
5. DNS 서버 포트 설정 (기본값: 53)
6. 설정 완료 후 로그인

### 4. 서비스 상태 확인
```bash
docker-compose ps
```

### 5. 로그 확인
```bash
docker-compose logs -f adguard-home
```

### 6. 서비스 중지
```bash
docker-compose down
```

## 구성 요소

### 1. AdGuard Home
- **컨테이너명**: `adguard_home`
- **이미지**: `adguard/adguardhome:latest`
- **기능**: DNS 서버 및 웹 관리 인터페이스

## 주요 기능

### 1. 광고 및 트래킹 차단
- **광고 차단**: 광고 도메인 자동 차단
- **트래킹 차단**: 사용자 추적 도메인 차단
- **피싱 차단**: 악성 사이트 차단
- **성인 콘텐츠 차단**: 선택적 성인 콘텐츠 차단

### 2. DNS 보안
- **DNS-over-HTTPS**: 암호화된 DNS 쿼리
- **DNS-over-TLS**: TLS를 통한 DNS 보안
- **DNSSEC**: DNS 보안 확장 지원

### 3. 네트워크 관리
- **쿼리 로그**: DNS 쿼리 기록 및 분석
- **통계**: 네트워크 사용량 통계
- **필터링**: 사용자 정의 필터 규칙
- **화이트리스트**: 예외 도메인 설정

### 4. 고급 기능
- **부모 제어**: 자녀 보호 기능
- **사용자 정의 필터**: 개인 필터 목록 추가
- **API 지원**: 외부 시스템 연동
- **백업/복원**: 설정 백업 및 복원

## 설정 가이드

### 1. 라우터 설정
네트워크 전체에서 AdGuard Home을 사용하려면 라우터의 DNS 설정을 변경하세요:

1. 라우터 관리 페이지 접속
2. DHCP 설정에서 DNS 서버를 AdGuard Home IP로 변경
3. 예: `192.168.1.100` (AdGuard Home이 실행 중인 서버 IP)

### 2. 개별 기기 설정
특정 기기에서만 사용하려면:

**Windows:**
1. 네트워크 설정 → 어댑터 옵션 변경
2. 네트워크 어댑터 우클릭 → 속성
3. IPv4 속성 → DNS 서버 주소 설정

**macOS:**
1. 시스템 환경설정 → 네트워크
2. 네트워크 서비스 선택 → 고급
3. DNS 탭에서 DNS 서버 추가

**Android:**
1. 설정 → Wi-Fi → 네트워크 정보
2. 네트워크 수정 → 고급 옵션
3. DNS 설정을 수동으로 변경

### 3. 필터 목록 관리
1. 웹 인터페이스에서 "Filters" 메뉴 접속
2. "Add filter" 클릭
3. 필터 목록 URL 입력 또는 직접 추가
4. 필터 활성화 및 설정

### 4. 사용자 정의 규칙
1. "Filters" → "Custom filtering rules"
2. 규칙 추가 예시:
   ```
   ||example.com^$block
   @@||example.com^$unblock
   ||example.com^$client=192.168.1.100
   ```

## 문제 해결

### 1. 포트 충돌
DNS 포트(53)가 이미 사용 중인 경우:
```bash
# 사용 중인 프로세스 확인
sudo lsof -i :53

# 기존 DNS 서비스 중지
sudo systemctl stop systemd-resolved
```

### 2. 권한 문제
```bash
# 디렉토리 권한 확인
ls -la work/ conf/

# 권한 수정
sudo chown -R 1000:1000 work/ conf/
```

### 3. 로그 확인
```bash
# 컨테이너 로그 확인
docker-compose logs adguard-home

# 실시간 로그 모니터링
docker-compose logs -f adguard-home
```

## 백업 및 복원

### 1. 설정 백업
```bash
# 설정 파일 백업
cp -r conf/ backup/conf-$(date +%Y%m%d)
cp -r work/ backup/work-$(date +%Y%m%d)
```

### 2. 설정 복원
```bash
# 백업에서 복원
cp -r backup/conf-20231201/* conf/
cp -r backup/work-20231201/* work/
```

## 보안 고려사항

1. **강력한 비밀번호 사용**: 관리자 계정에 강력한 비밀번호 설정
2. **방화벽 설정**: 필요한 포트만 외부에 노출
3. **정기 업데이트**: 최신 버전으로 정기 업데이트
4. **백업**: 정기적인 설정 백업
5. **모니터링**: 로그 및 통계 정기 확인 