# 기여 가이드

AIRUN API Documentation Hub에 기여해주셔서 감사합니다!

## 🎯 기여 유형

1. **버그 수정**: 문서의 오타, 오류 수정
2. **새로운 문서**: 새로운 API 엔드포인트 추가
3. **개선**: 예제 코드 개선, 설명 추가
4. **번역**: 다른 언어 버전 문서 추가

## 🚀 시작하기

### 1. 이슈 확인

```bash
# 이슈 목록 확인
gh issue list --repo chaeya/airun-api

# 또는 GitHub 웹사이트에서 이슈 확인
# https://github.com/chaeya/airun-api/issues
```

### 2. 포크 및 클론

```bash
# 포크 (GitHub 웹사이트에서)
# Fork 버튼 클릭

# 클론
git clone git@github.com:YOUR-USERNAME/airun-api.git
cd airun-api

# 업스트림 추가
git remote add upstream git@github.com:chaeya/airun-api.git
```

### 3. 브랜치 생성

```bash
git checkout -b your-branch-name
```

## 📝 문서 작성

### 파일 구조

```
{service}/
└── docs/
    └── {category}/
        └── {language}/
            └── DOC.md
```

### DOC.md 템플릿

```markdown
---
name: {api-name}
description: "간단하고 명확한 설명 (한 줄)"
metadata:
  languages: "javascript"
  versions: "1.0.0"
  revision: 1
  updated-on: "YYYY-MM-DD"
  source: maintainer
  tags: "tag1,tag2,tag3"
---

# {API 이름}

## 개요

이 API가 무엇인지, 어떻게 사용하는지 간단히 설명하세요.

## 기본 정보

**Base URL**: `http://localhost:5500`

**인증 방식**: `X-API-Key` 또는 `Authorization: Bearer <token>`

## 엔드포인트

### 1. 엔드포인트 이름

```javascript
// 간단한 설명
POST /api/v1/endpoint
Headers: { X-API-Key: 'your-key' }
Body: {
  field1: "value1",
  field2: "value2"
}

Response: {
  success: true,
  data: { ... }
}
```

**설명**:
- 파라미터 설명
- 응답 형식 설명
- 주의사항

## 코드 예시

### 기본 사용법

```javascript
// 전체 코드 예시
async function example() {
  const response = await fetch('http://localhost:5500/api/v1/endpoint', {
    method: 'POST',
    headers: {
      'X-API-Key': 'your-key',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      field1: 'value1'
    })
  });

  const result = await response.json();
  console.log(result.data);
}
```

## 에러 처리

```javascript
try {
  // API 호출
} catch (error) {
  // 에러 처리
  if (error.message.includes('UNAUTHORIZED')) {
    // 재인증
  }
}
```

## 일반적인 에러 코드

| 코드 | 설명 | 해결 방법 |
|------|------|----------|
| 400 | 잘못된 요청 | 요청 형식 확인 |
| 401 | 인증 실패 | API 키 확인 |

## 주의사항

- 주의할 점 1
- 주의할 점 2

## 추가 리소스

- 관련 링크
- 참고 문서
```

## 📋 registry.json 업데이트

새로운 문서를 추가할 때 `registry.json`을 업데이트하세요:

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-03-20",
  "entries": [
    {
      "id": "service-name/api-name",
      "name": "api-name",
      "description": "설명",
      "source": "maintainer",
      "tags": ["tag1", "tag2", "tag3"],
      "languages": [
        {
          "language": "javascript",
          "versions": [
            {
              "version": "1.0.0",
              "path": "service/docs/api/javascript",
              "files": ["DOC.md"],
              "size": 10000,
              "lastUpdated": "2026-03-20",
              "recommended": true
            }
          ],
          "recommendedVersion": "1.0.0"
        }
      ],
      "_type": "doc"
    }
  ]
}
```

## ✅ 체크리스트

PR을 생성하기 전 다음을 확인하세요:

### 문서 내용
- [ ] YAML frontmatter 포함
- [ ] 명확한 설명과 예제
- [ ] 실행 가능한 코드 예시
- [ ] 에러 처리 포함
- [ ] 최신 API 스펙 반영

### 형식
- [ ] 마크다운 형식 올바름
- [ ] 코드 블록 syntax highlighting
- [ ] 맞춤법 검사 완료
- [ ] 일관된 용어 사용

### 구조
- [ ] registry.json 업데이트
- [ ] 파일 경로 올바름
- [ ] 버전 정보 업데이트

## 🔄 PR 프로세스

### 1. 커밋

```bash
git add .
git commit -m "Add new API documentation for {service}"
```

### 2. 푸시

```bash
git push origin your-branch-name
```

### 3. Pull Request 생성

GitHub에서 PR 생성:

**제목**: `Add {service} API documentation`

**내용**:
```markdown
## 변경 내용
- 새로운 API 엔드포인트 추가
- 코드 예시 포함
- 에러 처리 설명 추가

## 테스트
- [x] chub 검색 동작 확인
- [x] chub get 동작 확인
- [x] 코드 예시 실행 테스트

## 스크린샷
(선택) 스크린샷 첨부
```

### 4. 리뷰 및 머지

- 최소 1명의 리뷰 필요
- 모든 체크리스트 항목 통과
- CI/CD 테스트 통과

## 🧪 테스트

### 로컬 테스트

```bash
# 1. 문서 경로 확인
ls -la service/docs/api/javascript/

# 2. registry.json 유효성 검사
cat registry.json | jq .

# 3. chub 테스트
chub search service-name
chub get service-name/api --lang js
```

### 통합 테스트

```bash
# 실제 API 호출 테스트
curl -X POST http://localhost:5500/api/v1/endpoint \
  -H "X-API-Key: your-key" \
  -d '{"field": "value"}'
```

## 📖 코딩 스타일

### 마크다운

```markdown
# H1 - 문서 제목 (YAML frontmatter 다음)
## H2 - 주요 섹션
### H3 - 하위 섹션
#### H4 - 세부 사항

**볼드체**, *이탤릭체*, `코드`

> 인용구

- 목록
- 항목
```

### 코드

````javascript
// syntax highlighting
function example() {
  return true;
}
````

### 테이블

```markdown
| 컬럼1 | 컬럼2 | 컬럼3 |
|-------|-------|-------|
| 데이터1 | 데이터2 | 데이터3 |
```

## 🎨 스타일 가이드

### 언어
- 한국어 위주 (팀 기준)
- 기술 용어는 영어 원문 유지
- 코드는 JavaScript/Node.js 스타일

### 네이밍
- API 이름: 영어 (예: `chat`, `rag`)
- 파일 이름: 소문자, 하이픈 (예: `api-docs.md`)
- 브랜치: 소문자, 하이픈 (예: `add-chat-api`)

### 설명
- 간결하고 명확하게
- "합니다" 보다는 평서문
- 코드 중심의 설명

## 🐛 버그 신고

버그를 발견하면 이슈를 생성하세요:

**제목**: `[Bug] {간단한 설명}`

**내용**:
```markdown
## 버그 설명
어떤 버그인지 설명

## 재현 단계
1. 단계 1
2. 단계 2
3. 버그 발생

## 기대 동작
어떻게 동작해야 하는지

## 실제 동작
실제로 어떻게 동작하는지

## 환경
- OS:
- Node.js 버전:
- chub 버전:
```

## 💡 기능 제안

새로운 기능을 제안하세요:

**제목**: `[Feature] {간단한 설명}`

**내용**:
```markdown
## 기능 설명
어떤 기능인지 설명

## 사용 사례
어떤 문제를 해결하는지

## 제안 구현
어떻게 구현할 것인지

## 대안
다른 가능한 접근 방법
```

## 📞 문의

질문이 있으면:

1. **이슈 생성**: GitHub Issues
2. **토론**: GitHub Discussions
3. **팀 채팅**: Slack/Teams

## 🙏 감사

기여해주셔서 감사합니다! 🎉

---

**팀**: Chaeya
**마지막 업데이트**: 2026-03-20
