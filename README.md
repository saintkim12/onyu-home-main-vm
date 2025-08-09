# Home Server - Main VM

이 프로젝트는 Docker 기반 홈서버 구성을 위한 메인 가상머신 설정입니다.

## 🏠 서버 구성

### 시스템 정보
- **플랫폼**: Docker + Docker Compose
- **운영체제**: Linux (가상머신)
- **관리 도구**: Portainer
- **자동화**: Watchtower (컨테이너 자동 업데이트)

### 네트워크 구성
- **내부 네트워크**: Docker 네트워크
- **외부 접근**: Tailscale VPN
- **도메인**: DuckDNS (동적 DNS)

## 📋 서비스 목록

### 🖥️ 관리 도구
| 서비스 | 포트 | 설명 | 상태 |
|--------|------|------|------|
| **Portainer** | 8100 | Docker GUI 관리 도구 | ✅ |
| **Dozzle** | 8400 | 컨테이너 로그 실시간 모니터링 | ✅ |

### 📸 미디어 & 백업
| 서비스 | 포트 | 설명 | 상태 |
|--------|------|------|------|
| **Immich** | 8200 | 사진/비디오 백업 서비스 | ✅ |
| **Immich Kiosk** | 8201 | 디지털 액자 모드 | ✅ |
| **Audiforge** | 8210 | PDF to MusicXML | ✅ |

### 🌐 네트워크 & 보안
| 서비스 | 포트 | 설명 | 상태 |
|--------|------|------|------|
| **Tailscale** | - | VPN 서비스 (호스트 모드) | ✅ |
| **DuckDNS** | - | 동적 DNS 업데이트 | ✅ |
| **Authentik** | 8300 | 인증 프록시 서비스 (NPM 뒤에 위치) | ✅ |
| **Adguard Home** | 8310 | 광고 차단 DNS | 🆕 |

### 🔄 자동화
| 서비스 | 포트 | 설명 | 상태 |
|--------|------|------|------|
| **Watchtower** | - | 컨테이너 자동 업데이트 | ✅ |

## 🔌 포트 규칙

### 포트 범위별 분류
| 범위 | 용도 | 서비스 예시 |
|------|------|-------------|
| `8100~8199` | 관리 도구 | Portainer (8100) |
| `8200~8299` | 미디어/백업 | Immich (8200), Immich Kiosk (8201) |
| `8300~8399` | 네트워크 도구 | (예약됨) |
| `8400~8499` | 모니터링/로깅 | Dozzle (8400) |
| `8500~8599` | 자동화/백업 | (예약됨) |
| `8600~8699` | 개발/테스트 | (예약됨) |

### 현재 포트 할당
| 서비스 | 컨테이너 포트 | 호스트 포트 | 접속 URL |
|--------|--------------|-------------|----------|
| Portainer | 9000 | 8100 | http://localhost:8100 |
| Dozzle | 8080 | 8400 | http://localhost:8400 |
| Immich | 2283 | 8200 | http://localhost:8200 |
| Immich Kiosk | 3000 | 8201 | http://localhost:8201 |
| Authentik | 9000 | 8300 | http://localhost:8300 |

## 🚀 시작하기

### 1. 환경 설정
```bash
# 프로젝트 디렉토리로 이동
cd main-vm

# 환경 변수 파일 복사 (필요시)
cp stack.env.example stack.env

# 환경 변수 편집
nano stack.env
```

### 2. 전체 서비스 시작
```bash
# 모든 서비스 시작
./init.sh

# 또는 개별 서비스 시작
cd docker/portainer && docker-compose up -d
cd docker/dozzle && docker-compose up -d
cd docker/immich && docker-compose up -d
# ... 기타 서비스들
```

### 3. 서비스 상태 확인
```bash
# 전체 상태 확인
docker ps

# 개별 서비스 로그 확인
cd docker/portainer && docker-compose logs -f
```

## 📁 디렉토리 구조

```
main-vm/
├── docker/                    # Docker 서비스들
│   ├── dozzle/               # 로그 모니터링
│   ├── duckdns/              # 동적 DNS
│   ├── firefox/              # 웹 브라우저
│   ├── immich/               # 사진 백업
│   ├── tailscale/            # VPN
│   └── watchtower/           # 자동 업데이트
├── portainer/                # Docker 관리 도구
├── init.sh                   # 초기화 스크립트
├── restart.sh                # 재시작 스크립트
├── stack.env                 # 환경 변수
└── README.md                 # 이 파일
```

## 🔧 관리 명령어

### 전체 서비스 관리
```bash
# 모든 서비스 시작
./init.sh

# 모든 서비스 재시작
./restart.sh

# 모든 서비스 중지
docker-compose -f docker/*/docker-compose.yaml down
```

### 개별 서비스 관리
```bash
# 특정 서비스 시작
cd docker/[서비스명] && docker-compose up -d

# 특정 서비스 중지
cd docker/[서비스명] && docker-compose down

# 특정 서비스 로그 확인
cd docker/[서비스명] && docker-compose logs -f
```

### 시스템 관리
```bash
# Docker 시스템 정리
docker system prune -a

# 사용하지 않는 볼륨 정리
docker volume prune

# 사용하지 않는 네트워크 정리
docker network prune
```

## 🔒 보안 고려사항

### 네트워크 보안
- **내부 접근**: 로컬 네트워크에서만 접근 가능
- **외부 접근**: Tailscale VPN을 통한 안전한 접근
- **방화벽**: 필요한 포트만 개방

### 데이터 보안
- **백업**: 정기적인 데이터 백업 권장
- **암호화**: 민감한 데이터는 암호화 저장
- **업데이트**: Watchtower를 통한 자동 보안 업데이트

### 접근 제어
- **관리자 계정**: 강력한 비밀번호 사용
- **권한 관리**: 최소 권한 원칙 적용
- **로그 모니터링**: Dozzle을 통한 실시간 로그 확인

## 📊 모니터링

### 실시간 모니터링
- **Portainer**: 컨테이너 상태 및 리소스 사용량
- **Dozzle**: 실시간 로그 스트리밍
- **Watchtower**: 자동 업데이트 상태

### 알림 설정
```bash
# Watchtower 알림 설정 (선택사항)
# docker/watchtower/docker-compose.yaml에서 알림 설정 추가
```

## 🛠️ 문제 해결

### 일반적인 문제들

#### 서비스가 시작되지 않는 경우
```bash
# 로그 확인
docker-compose logs [서비스명]

# 포트 충돌 확인
netstat -tulpn | grep :[포트번호]

# Docker 데몬 상태 확인
sudo systemctl status docker
```

#### 네트워크 연결 문제
```bash
# Docker 네트워크 확인
docker network ls

# 컨테이너 네트워크 설정 확인
docker inspect [컨테이너명]
```

#### 디스크 공간 부족
```bash
# Docker 사용량 확인
docker system df

# 불필요한 리소스 정리
docker system prune -a
```

## 📚 참고 자료

### 공식 문서
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Portainer Documentation](https://docs.portainer.io/)

### 서비스별 문서
- [Immich Documentation](https://immich.app/docs/)
- [Tailscale Documentation](https://tailscale.com/kb/)

## 🤝 기여하기

1. 이슈 리포트 생성
2. 기능 요청 제안
3. 코드 개선 제안
4. 문서 개선 제안

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

---

**마지막 업데이트**: 2024년 12월
**버전**: 1.0.0

---

# 실행스크립트
```bash
curl -s https://raw.githubusercontent.com/saintkim12/onyu-home-main-vm/main/init.sh | sh
```