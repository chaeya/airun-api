# 팀원 설정 가이드

AIRUN API Documentation Hub를 사용하기 위한 팀원 설정 가이드입니다.

## 🚀 5분 설정

### Step 1: chub 설치 (1분)

```bash
npm install -g @aisuite/chub
```

### Step 2: 저장소 클론 (1분)

```bash
git clone git@github.com:chaeya/airun-api.git ~/airun-api
```

### Step 3: chub 설정 (1분)

```bash
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

### Step 4: 동작 테스트 (2분)

```bash
# 검색 테스트
chub search airun

# 문서 가져오기 테스트
chub get airun/api --lang js
```

## ✅ 설정 확인

### 동작 테스트

```bash
# 1. 검색 테스트
chub search airun

# 예상 출력:
# airun/api  [doc]  js  [maintainer] (airun-team)
#      AIRUN REST API 서버 엔드포인트 가이드...

# 2. 문서 가져오기
chub get airun/api --lang js | head -20

# 3. 특정 섹션 검색
chub get airun/api --lang js | grep -A 10 "## 3. RAG Domain"
```

## 📚 사용법

### 기본 명령어

```bash
# 문서 검색
chub search <keyword>

# 문서 가져오기
chub get <id> --lang js

# 파일로 저장
chub get <id> --lang js -o ~/Desktop/api-docs.md

# 여러 문서 가져오기
chub get airun/api openai/chat --lang js
```

### 실전 예시

#### 예시 1: RAG 검색

```bash
# RAG 문서 보기
chub get airun/api --lang js | grep -A 30 "## 3. RAG Domain"

# 파일로 저장
chub get airun/api --lang js -o ~/airun-rag-guide.md
```

#### 예시 2: 채팅 API

```bash
# Chat API 문서 보기
chub get airun/api --lang js | grep -A 20 "### 1. Chat API"
```

#### 예시 3: 전체 문서

```bash
# 전체 문서를 파일로 저장
chub get airun/api --lang js > ~/airun-api-complete.md

# 또는 리다이렉트 없이
chub get airun/api --lang js -o ~/airun-api-complete.md
```

## 🔄 업데이트 방법

### 수동 업데이트

```bash
cd ~/airun-api
git pull origin master
```

### 자동 업데이트 (선택)

```bash
# crontab에 추가
crontab -e

# 매일 새벽 2시에 자동 업데이트
0 2 * * * cd ~/airun-api && git pull origin master
```

## 🤝 기여 방법

### 1. 이슈 확인

```bash
# 이슈 목록
gh issue list --repo chaeya/airun-api

# 또는 웹사이트
# https://github.com/chaeya/airun-api/issues
```

### 2. 포크 및 브랜치

```bash
# 포크 (GitHub 웹사이트에서)
# Fork 버튼 클릭

# 포크된 저장소 클론
git clone git@github.com:YOUR-USERNAME/airun-api.git
cd airun-api

# 브랜치 생성
git checkout -b add-new-docs
```

### 3. 문서 수정

```bash
# 새로운 API 문서 추가
mkdir -p new-service/docs/api/javascript
vim new-service/docs/api/javascript/DOC.md

# registry.json 업데이트
vim registry.json

# 커밋
git add .
git commit -m "Add new API documentation"
git push origin add-new-docs
```

### 4. Pull Request

GitHub에서 PR 생성:
1. 비교: `add-new-docs` → `master`
2. 제목: `Add new API documentation`
3. 내용: 변경 사항 설명
4. 리뷰 요청: 팀원들 태그

## 📖 문서 작성 템플릿

### DOC.md 템플릿

```markdown
---
name: {api-name}
description: "설명"
metadata:
  languages: "javascript"
  versions: "1.0.0"
  updated-on: "YYYY-MM-DD"
  source: maintainer
  tags: "tag1,tag2"
---

# {API 이름}

## 개요
간단한 설명

## 엔드포인트
### POST /api/v1/endpoint
코드 예시

## 에러 처리
에러 케이스
```

### registry.json 템플릿

```json
{
  "id": "service/api-name",
  "name": "api-name",
  "description": "설명",
  "tags": ["tag1", "tag2"],
  "languages": [
    {
      "language": "javascript",
      "versions": [
        {
          "version": "1.0.0",
          "path": "service/docs/api/javascript",
          "files": ["DOC.md"],
          "lastUpdated": "2026-03-20"
        }
      ]
    }
  ]
}
```

## 🐛 문제 해결

### 문제: chub search 결과 없음

```bash
# 해결: config.yaml 확인
cat ~/.chub/config.yaml

# path가 올바른지 확인
ls ~/airun-api/registry.json
```

### 문제: 문서가 나오지 않음

```bash
# 해결: 최신으로 업데이트
cd ~/airun-api && git pull

# 캐시 확인
chub search airun --json
```

### 문제: 권한 오류

```bash
# 해결: SSH 키 확인
ssh -T git@github.com

# 또는 HTTPS URL 사용
git remote set-url origin https://github.com/chaeya/airun-api.git
```

## 💡 팁

### 1. 빠른 검색

```bash
# alias 설정
echo 'alias airun-docs="chub get airun/api --lang js"' >> ~/.zshrc
source ~/.zshrc

# 사용
airun-docs | grep "RAG"
```

### 2. 즐겨찾기

```bash
# 자주 사용하는 문서를 파일로 저장
chub get airun/api --lang js > ~/docs/airun-api.md

# 에디터에서 바로 열기
vim ~/docs/airun-api.md
```

### 3. 쉘 함수

```bash
# ~/.zshrc 또는 ~/.bashrc에 추가

airun_search() {
  chub get airun/api --lang js | grep -A 20 "$1"
}

# 사용
airun_search "RAG Domain"
airun_search "Chat API"
```

## 📞 도움말

### 문의처

1. **GitHub Issues**: https://github.com/chaeya/airun-api/issues
2. **팀 채팅**: Slack/Teams
3. **팀 리더**: 연락처

### 유용한 링크

- [Context Hub 문서](https://github.com/andrewyng/context-hub)
- [AIRUN API Swagger](http://localhost:5500/api/v1/docs)
- [기여 가이드](CONTRIBUTING.md)

## ✅ 설정 완료 체크리스트

- [ ] chub 설치 완료
- [ ] 저장소 클론 완료
- [ ] config.yaml 설정 완료
- [ ] 검색 테스트 통과
- [ ] 문서 가져오기 테스트 통과
- [ ] 업데이트 방법 이해
- [ ] 기여 방법 숙지

모든 항목을 완료하셨다면 설정 완료! 🎉

---

**팀**: Chaeya
**마지막 업데이트**: 2026-03-20
**버전**: 1.0.0
