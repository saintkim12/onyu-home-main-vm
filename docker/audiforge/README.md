# Audiforge

Audiforge는 PDF 악보를 MusicXML 형식으로 변환하는 Go 기반 웹 서비스입니다. [Audiveris](https://github.com/Audiveris/audiveris) 엔진을 활용하여 고품질의 악보 변환을 제공합니다.

## 서비스 정보

- **웹 인터페이스**: `http://localhost:${AUDIFORGE_PORT:-8080}`
- **API 엔드포인트**: `http://localhost:${AUDIFORGE_PORT:-8080}/api`
- **업로드 디렉토리**: `/tmp/uploads`
- **다운로드 디렉토리**: `/tmp/downloads`

## 시작하기

### 1. 환경 변수 설정
Audiforge를 시작하기 전에 환경 변수 파일을 설정해야 합니다:

```bash
# .env 파일 생성
cp env.example .env
```

필수 환경 변수:
- `AUDIFORGE_PORT`: 웹 서비스 포트 (기본값: 8080)
- `LOG_LEVEL`: 로그 레벨 (기본값: info, debug 가능)
- `UPLOAD_PATH`: PDF 업로드 경로 (기본값: /tmp/uploads)
- `DOWNLOAD_PATH`: 변환된 파일 다운로드 경로 (기본값: /tmp/downloads)
- `CLEANUP_INTERVAL`: 정리 주기 (기본값: 1h)
- `TZ`: 시간대 설정 (기본값: Asia/Seoul)

### 2. 서비스 시작
```bash
docker-compose up -d
```

### 3. 서비스 상태 확인
```bash
docker-compose ps
```

### 4. 로그 확인
```bash
docker-compose logs -f audiforge
```

### 5. 서비스 중지
```bash
docker-compose down
```

## 구성 요소

### 1. Audiforge
- **컨테이너명**: `audiforge`
- **이미지**: `nirmata1/audiforge:latest`
- **기능**: PDF 악보를 MusicXML로 변환하는 웹 서비스

## 주요 기능

### 1. 악보 변환
- **PDF → MusicXML**: PDF 악보를 MusicXML 형식으로 변환
- **다중 악장 지원**: 여러 악장이 포함된 악보 자동 감지
- **배치 처리**: 여러 PDF 파일 동시 처리
- **고품질 변환**: Audiveris 엔진을 통한 정확한 악보 인식

### 2. 웹 인터페이스
- **직관적인 UI**: 사용자 친화적인 웹 인터페이스
- **드래그 앤 드롭**: 간편한 파일 업로드
- **실시간 상태**: 변환 진행 상황 실시간 모니터링
- **다운로드**: 변환 완료된 파일 ZIP 형태로 다운로드

### 3. API 지원
- **RESTful API**: 외부 시스템 연동을 위한 API 제공
- **비동기 처리**: 대용량 파일 처리 시 비동기 작업
- **상태 조회**: 변환 작업 상태 실시간 조회
- **파일 관리**: 업로드/다운로드 파일 관리

## API 엔드포인트

### 1. 파일 업로드
```
POST /upload
Content-Type: multipart/form-data

파일 업로드 후 작업 ID 반환
```

### 2. 상태 조회
```
GET /status/{id}

변환 작업의 현재 상태 조회
```

### 3. 파일 다운로드
```
GET /download/{id}

변환 완료된 MusicXML 파일들을 ZIP 형태로 다운로드
```

## 사용법

### 1. 웹 인터페이스 사용
1. 웹 브라우저에서 `http://localhost:8080` 접속
2. PDF 악보 파일을 드래그 앤 드롭으로 업로드
3. 변환 진행 상황 모니터링
4. 변환 완료 후 ZIP 파일 다운로드

### 2. API 사용
```bash
# 파일 업로드
curl -X POST -F "file=@score.pdf" http://localhost:8080/upload

# 상태 조회
curl http://localhost:8080/status/{job_id}

# 파일 다운로드
curl -O http://localhost:8080/download/{job_id}
```

### 3. 지원 파일 형식
- **입력**: PDF (악보 파일)
- **출력**: MusicXML, ZIP (여러 파일 포함 시)

## 설정

### 1. 로그 레벨 설정
```bash
# .env 파일에서 설정
LOG_LEVEL=debug  # 상세한 로그 출력
LOG_LEVEL=info   # 기본 정보 로그
```

### 2. 정리 주기 설정
```bash
# .env 파일에서 설정
CLEANUP_INTERVAL=1h    # 1시간마다 정리
CLEANUP_INTERVAL=30m   # 30분마다 정리
```

### 3. 디렉토리 경로 설정
```bash
# .env 파일에서 설정
UPLOAD_PATH=/path/to/uploads      # 업로드 디렉토리
DOWNLOAD_PATH=/path/to/downloads  # 다운로드 디렉토리
```

## 문제 해결

### 1. 변환 실패
```bash
# 로그 확인
docker-compose logs audiforge

# 디스크 공간 확인
df -h

# 권한 확인
ls -la /tmp/uploads /tmp/downloads
```

### 2. 포트 충돌
```bash
# 포트 사용 확인
lsof -i :8080

# .env 파일에서 포트 변경
AUDIFORGE_PORT=8081
```

### 3. 메모리 부족
```bash
# 컨테이너 리소스 확인
docker stats audiforge

# 시스템 메모리 확인
free -h
```

## 성능 최적화

### 1. 대용량 파일 처리
- **청크 업로드**: 큰 파일은 청크 단위로 분할 업로드
- **배치 처리**: 여러 파일을 한 번에 업로드하여 처리 효율성 향상
- **비동기 처리**: 변환 작업을 백그라운드에서 처리

### 2. 리소스 관리
- **자동 정리**: 주기적인 임시 파일 정리
- **메모리 최적화**: 효율적인 메모리 사용
- **디스크 공간**: 업로드/다운로드 디렉토리 모니터링

## 보안 고려사항

1. **파일 검증**: 업로드된 PDF 파일의 유효성 검사
2. **접근 제어**: API 엔드포인트 접근 제한 (필요시)
3. **파일 격리**: 업로드/다운로드 디렉토리 분리
4. **정기 정리**: 임시 파일의 주기적 삭제
5. **로깅**: 모든 작업에 대한 상세한 로그 기록

## 백업 및 복원

### 1. 설정 백업
```bash
# 환경 변수 파일 백업
cp .env backup/env-$(date +%Y%m%d)
```

### 2. 데이터 백업
```bash
# 업로드/다운로드 디렉토리 백업
cp -r uploads/ backup/uploads-$(date +%Y%m%d)
cp -r downloads/ backup/downloads-$(date +%Y%m%d)
```

## 모니터링

### 1. 서비스 상태
```bash
# 컨테이너 상태 확인
docker-compose ps

# 리소스 사용량 확인
docker stats audiforge
```

### 2. 로그 모니터링
```bash
# 실시간 로그 확인
docker-compose logs -f audiforge

# 특정 시간대 로그 확인
docker-compose logs --since="2024-01-01T00:00:00" audiforge
```

### 3. 성능 지표
- **변환 성공률**: 전체 변환 작업 중 성공 비율
- **처리 시간**: 평균 변환 소요 시간
- **동시 처리**: 동시에 처리 가능한 작업 수
- **오류율**: 변환 실패 비율

## 참고 자료

- [GitHub 저장소](https://github.com/Nirmata-1/Audiforge)
- [Audiveris 프로젝트](https://github.com/Audiveris/audiveris)
- [MusicXML 표준](https://www.musicxml.com/)
- [Docker 공식 이미지](https://hub.docker.com/r/nirmata1/audiforge) 