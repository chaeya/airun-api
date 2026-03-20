# AIRUN API Documentation Hub

> Context Hub 기반의 AIRUN API 문서 중앙 저장소

## 🚀 빠른 시작

### 1. chub 설치

```bash
npm install -g @aisuite/chub
```

### 2. 저장소 클론

```bash
git clone git@github.com:chaeya/airun-api.git ~/airun-api
cd ~/airun-api
```

### 3. chub 설정

```bash
# config.yaml 생성
mkdir -p ~/.chub
cat > ~/.chub/config.yaml << 'EOF'
sources:
  - name: default
    url: https://cdn.aichub.org/v1
  - name: airun-team
    path: ~/airun-api

refresh_interval: 3600
EOF
```

### 4. 사용법

```bash
# AIRUN API 문서 검색
chub search airun

# 문서 가져오기
chub get airun/api --lang js

# 업데이트 (최신 문서)
cd ~/airun-api && git pull
```

## 📚 문서 구조

```
airun-api/
├── registry.json          # 문서 레지스트리
├── README.md              # 이 파일
├── CONTRIBUTING.md        # 기여 가이드
└── airun/
    └── docs/
        └── api/
            └── javascript/
                └── DOC.md  # AIRUN API 문서
```

## 📖 현재 문서화된 API

### AIRUN REST API (v1.0.0)

**13개 도메인, 100개 이상의 엔드포인트**

1. **Public Endpoints** - 헬스 체크, 설정
2. **Auth Domain** - 로그인, 사용자 관리
3. **RAG Domain** - 문서 검색, 임베딩
4. **AI Domain** - 채팅, 코드 실행, 에이전트
5. **Security Domain** - 보안 설정, API 키
6. **Sessions Domain** - 세션 관리
7. **Webhooks Domain** - 웹훅 설정
8. **Config Domain** - 설정 관리
9. **Report Domain** - 보고서 생성
10. **Tasks Domain** - 작업 관리
11. **Projects Domain** - 프로젝트 관리
12. **Context Domain** - 컨텍스트 관리
13. **Queue Domain** - 큐 관리

## 🔧 문서 사용 예시

### RAG 검색

```bash
# 문서 가져오기
chub get airun/api --lang js > /tmp/airun-api-docs.md

# 문서에서 RAG 부분 검색
grep -A 30 "## 3. RAG Domain" /tmp/airun-api-docs.md
```

### 에이전트 사용

```javascript
// Claude Code에서 자동으로 사용
// "AIRUN API로 채팅하는 방법 알려줘"
// → chub가 자동으로 최신 문서를 참조하여 답변
```

## 🤝 기여 방법

### 1. 브랜치 생성

```bash
git checkout -b add-new-api-docs
```

### 2. 문서 작성/수정

```bash
# 새로운 API 문서 추가
mkdir -p new-service/docs/api/javascript
vim new-service/docs/api/javascript/DOC.md

# registry.json 업데이트
vim registry.json
```

### 3. 커밋 및 푸시

```bash
git add .
git commit -m "Add new API documentation"
git push origin add-new-api-docs
```

### 4. Pull Request 생성

GitHub에서 PR 생성 후 팀 리뷰 요청

## 📝 문서 작성 가이드

### DOC.md 형식

```markdown
---
name: {api-name}
description: "간단한 설명"
metadata:
  languages: "javascript"
  versions: "1.0.0"
  updated-on: "YYYY-MM-DD"
  source: maintainer
  tags: "tag1,tag2,tag3"
---

# {API 이름}

## 개요
간단한 개요

## 엔드포인트
### POST /api/v1/endpoint
코드 예시

## 에러 처리
일반적인 에러 케이스
```

### registry.json 형식

```json
{
  "version": "1.0.0",
  "entries": [
    {
      "id": "service-name/api-name",
      "name": "api-name",
      "description": "설명",
      "languages": [
        {
          "language": "javascript",
          "versions": [
            {
              "version": "1.0.0",
              "path": "service/docs/api/javascript",
              "files": ["DOC.md"],
              "size": 10000,
              "lastUpdated": "2026-03-20"
            }
          ]
        }
      ]
    }
  ]
}
```

## 🔄 자동 업데이트

### GitHub Actions 설정

```yaml
# .github/workflows/update-docs.yml
name: Update Documentation

on:
  push:
    branches: [main]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify team
        run: |
          echo "📚 문서가 업데이트되었습니다!"
          echo "팀원들은 다음 명령어로 업데이트하세요:"
          echo "cd ~/airun-api && git pull"
```

## 🧪 테스트

### 문서 유효성 검사

```bash
# registry.json 유효성 검사
cat registry.json | jq . > /dev/null

# chub 동작 테스트
chub search airun
chub get airun/api --lang js
```

## 📊 문서 통계

| 항목 | 수량 |
|------|------|
| 도메인 | 13개 |
| 엔드포인트 | 100개+ |
| 코드 예시 | 150개+ |
| 페이지 수 | 500줄+ |

## 🔗 관련 링크

- [AIRUN 프로젝트](https://github.com/chaeya/airun)
- [Context Hub](https://github.com/andrewyng/context-hub)
- [API Swagger 문서](http://localhost:5500/api/v1/docs)
- [통합 테스트 결과](https://github.com/chaeya/airun/blob/main/tests/integration/TEST_SUMMARY.md)

## 💡 팁

1. **정기적 업데이트**: `git pull`로 최신 문서 유지
2. **오프라인 사용**: 클론 후 인터넷 없이 사용 가능
3. **버전 관리**: Git 히스토리로 문서 변경 추적
4. **협업**: PR을 통한 팀 문서 검토

## 📄 라이선스

MIT License

---

**팀**: Chaeya
**마지막 업데이트**: 2026-03-20
**버전**: 1.0.0
