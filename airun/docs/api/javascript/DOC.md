---
name: api
description: "AIRUN REST API 서버 엔드포인트 가이드 - 100개 이상의 엔드포인트, 13개 도메인 완전 문서화"
metadata:
  languages: "javascript"
  versions: "1.0.0"
  revision: 2
  updated-on: "2026-03-19"
  source: maintainer
  tags: "airun,api,rest,ai,chat,rag,websearch,report,tasks,projects"
---

# AIRUN REST API 가이드

AIRUN 시스템의 REST API 엔드포인트 사용법입니다. 모든 API는 `http://localhost:5500`에서 실행됩니다.

## 기본 정보

**Base URL**: `http://localhost:5500`

**API 문서**: `http://localhost:5500/api/v1/docs`

**인증 방식**:
- `X-API-Key`: AI 기능 관련 엔드포인트 (chat, code, agent, report, rag, web)
- `Authorization: Bearer <token>`: JWT 토큰 인증 (사용자 관리, 설정)

## 인증

### API 키 인증

```javascript
const headers = {
  'X-API-Key': 'your-api-key',
  'Content-Type': 'application/json'
};

fetch('http://localhost:5500/api/v1/chat', {
  method: 'POST',
  headers: headers,
  body: JSON.stringify({ prompt: 'Hello' })
});
```

### JWT 토큰 인증

```javascript
// 로그인하여 토큰 획득
const loginResponse = await fetch('http://localhost:5500/api/v1/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'admin',
    password: 'admin1234'
  })
});

const { data: { token } } = await loginResponse.json();

// 토큰으로 인증된 요청
const headers = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
};

fetch('http://localhost:5500/api/v1/users/profile', {
  method: 'GET',
  headers: headers
});
```

## 1. Public Endpoints (인증 불필요)

### Health Check

```javascript
// 기본 상태 확인
GET /health
Response: { status: "ok" }

// API 상태 확인
GET /api/v1/health
Response: { status: "ok", timestamp: "2026-03-19T12:00:00Z" }

// 기본 설정 조회
GET /api/v1/config/defaults
Response: {
  providers: [...],
  models: [...],
  features: {...}
}

// 전체 설정 조회
GET /api/v1/config
Response: { ... }
```

## 2. Auth Domain (인증/인가)

### 로그인/로그아웃

```javascript
// 로그인
POST /api/v1/auth/login
Body: {
  username: "admin",
  password: "admin1234"
}
Response: {
  success: true,
  data: {
    user: { id: 1, username: "admin", ... },
    token: "jwt-token",
    apiKeys: [...]
  }
}

// 현재 사용자 정보
GET /api/v1/auth/me
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, username: "admin", role: "admin", ... }
}

// 로그아웃
POST /api/v1/auth/logout
Headers: { Authorization: 'Bearer token' }
Response: { success: true }

// 비밀번호 변경
POST /api/v1/auth/change-password
Headers: { Authorization: 'Bearer token' }
Body: {
  currentPassword: "oldpassword",
  newPassword: "newpassword"
}

// 활동 로그
GET /api/v1/auth/activities
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { activities: [...], total: 100 }
}
```

### 사용자 관리 (관리자)

```javascript
// 사용자 목록
GET /api/v1/admin/users
Headers: { Authorization: 'Bearer token' }
Query: { page: 1, limit: 20, search: "keyword" }
Response: {
  success: true,
  data: { users: [...], total: 50 }
}

// 사용자 상세
GET /api/v1/admin/users/{userId}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, username: "admin", ... }
}

// 사용자 상태 변경
PUT /api/v1/admin/users/{userId}/status
Headers: { Authorization: 'Bearer token' }
Body: { status: "active" | "inactive" | "suspended" }
Response: { success: true }

// 사용자 역할 변경
POST /api/v1/admin/users/{userId}/role
Headers: { Authorization: 'Bearer token' }
Body: { role: "admin" | "user" }
Response: { success: true }
```

## 3. RAG Domain (문서 검색)

### 검색

```javascript
// 비동기 검색
POST /api/v1/rag/search
Headers: { X-API-Key: 'your-key' }
Body: {
  query: "검색어",
  topK: 5,
  filters: { category: "docs" }
}
Response: {
  success: true,
  jobId: "123",
  status: "queued"
}

// 동기 검색
POST /api/v1/rag/search/sync
Headers: { X-API-Key: 'your-key' }
Body: {
  query: "검색어",
  topK: 5
}
Response: {
  success: true,
  data: {
    results: [
      {
        content: "문서 내용",
        metadata: { source: "file.pdf", page: 1 },
        score: 0.95
      }
    ]
  }
}
```

### 문서 관리

```javascript
// 텍스트 추가
POST /api/v1/rag/add
Headers: { X-API-Key: 'your-key' }
Body: {
  content: "문서 내용",
  metadata: { title: "문서 제목", category: "docs" }
}
Response: { success: true, data: { documentId: "123" } }

// 파일 업로드
POST /api/v1/rag/upload
Headers: { X-API-Key: 'your-key' }
Body: FormData {
  file: File,
  metadata: JSON.stringify({ title: "파일 제목" })
}
Response: { success: true, data: { documentId: "123" } }

// 파일 삭제
DELETE /api/v1/rag/file
Headers: { X-API-Key: 'your-key' }
Body: { filePath: "/path/to/file" }
Response: { success: true }

// 문서 목록
GET /api/v1/rag/list
Headers: { X-API-Key: 'your-key' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { documents: [...], total: 100 }
}

// 파일 목록
GET /api/v1/rag/files
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: { files: [...] }
}

// 청크 목록
GET /api/v1/rag/chunks
Headers: { X-API-Key: 'your-key' }
Query: { documentId: "123" }
Response: {
  success: true,
  data: { chunks: [...] }
}
```

### RAG 초기화

```javascript
// 초기화 시작
POST /api/v1/rag/init
Headers: { X-API-Key: 'your-key' }
Body: {
  path: "/path/to/documents",
  force: false
}
Response: { success: true, jobId: "123" }

// 초기화 상태 확인
GET /api/v1/rag/init-status
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: {
    status: "completed" | "processing" | "failed",
    progress: 100,
    total: 500,
    processed: 500
  }
}

// 통계
GET /api/v1/rag/stats
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: {
    totalDocuments: 100,
    totalChunks: 5000,
    totalSize: "1.2GB"
  }
}

// 정리
POST /api/v1/rag/cleanup
Headers: { X-API-Key: 'your-key' }
Body: {
  olderThan: "2024-01-01",
  confirm: true
}
Response: { success: true }
```

## 4. AI Domain

### Chat

```javascript
// 비동기 채팅
POST /api/v1/chat
Headers: { X-API-Key: 'your-key' }
Body: {
  prompt: "안녕하세요",
  sessionId: "optional-session-id",
  options: {
    provider: "ollama",
    model: "hamonize:latest",
    temperature: 0.7,
    max_tokens: 2000,
    rag: true,
    web: false
  }
}
Response: {
  success: true,
  jobId: "1",
  status: "queued"
}

// 동기 채팅
POST /api/v1/chat/sync
Headers: { X-API-Key: 'your-key' }
Body: {
  prompt: "안녕하세요",
  options: { ... }
}
Response: {
  success: true,
  data: {
    response: "안녕하세요! 무엇을 도와드릴까요?",
    sessionId: "session-id",
    usage: { total_tokens: 100 }
  }
}
```

### Code Execution

```javascript
// 비동기 코드 실행
POST /api/v1/code
Headers: { X-API-Key: 'your-key' }
Body: {
  code: "print('Hello World')",
  language: "python"
}
Response: {
  success: true,
  jobId: "2",
  status: "queued"
}

// 동기 코드 실행
POST /api/v1/code/sync
Headers: { X-API-Key: 'your-key' }
Body: {
  code: "print('Hello World')",
  language: "python"
}
Response: {
  success: true,
  data: {
    output: "Hello World\n",
    error: null,
    executionTime: 0.5
  }
}
```

### Agent

```javascript
// 에이전트 실행
POST /api/v1/agent/run
Headers: { X-API-Key: 'your-key' }
Body: {
  agentId: "research-agent",
  input: "AI 최신 동향 조사",
  context: {}
}
Response: {
  success: true,
  jobId: "3",
  status: "queued"
}

// 에이전트 상태 확인
GET /api/v1/agent/status/{jobId}
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: {
    status: "completed",
    result: { ... }
  }
}
```

### Web Search

```javascript
// 웹 검색
POST /api/v1/web/search
Headers: { X-API-Key: 'your-key' }
Body: {
  query: "검색어",
  numResults: 10,
  language: "ko"
}
Response: {
  success: true,
  data: {
    results: [
      {
        title: "결과 제목",
        url: "https://example.com",
        snippet: "요약 내용"
      }
    ]
  }
}
```

### Providers & Models

```javascript
// 프로바이더 목록
GET /api/v1/ai/providers
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: {
    providers: ["openai", "anthropic", "gemini", "ollama", ...]
  }
}

// 프로바이더별 모델 목록
GET /api/v1/ai/providers/{provider}/models
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: {
    models: [
      {
        id: "gpt-4",
        name: "GPT-4",
        contextLength: 8192,
        capabilities: ["chat", "function-calling"]
      }
    ]
  }
}
```

## 5. Security Domain

### 보안 설정

```javascript
// 보안 설정 조회
GET /api/v1/security/settings
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: {
    inputGuardrailEnabled: true,
    maskSensitiveData: true,
    maxRetries: 3,
    ...
  }
}

// 보안 설정 업데이트
PUT /api/v1/security/settings
Headers: { Authorization: 'Bearer token' }
Body: {
  inputGuardrailEnabled: false,
  maskSensitiveData: true
}
Response: { success: true }

// 보안 이벤트
GET /api/v1/security/events
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0, type: "all" }
Response: {
  success: true,
  data: { events: [...], total: 100 }
}

// 보안 로그
GET /api/v1/security/logs
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { logs: [...], total: 500 }
}
```

### API Keys

```javascript
// API 키 생성
POST /api/v1/api-keys
Headers: { Authorization: 'Bearer token' }
Body: {
  name: "New API Key",
  permissions: ["chat", "rag"]
}
Response: {
  success: true,
  data: {
    id: 1,
    key: "airun_1_...",
    name: "New API Key"
  }
}

// API 키 목록
GET /api/v1/api-keys
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { apiKeys: [...] }
}

// API 키 상세
GET /api/v1/api-keys/{id}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, name: "...", status: "active" }
}

// API 키 삭제
DELETE /api/v1/api-keys/{id}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }
```

### Audit Logs

```javascript
// 감사 로그
GET /api/v1/audit/logs
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0, userId: 1, action: "login" }
Response: {
  success: true,
  data: { logs: [...], total: 1000 }
}
```

## 6. Sessions Domain

```javascript
// 세션 목록
GET /api/v1/sessions
Headers: { X-API-Key: 'your-key' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { sessions: [...], total: 50 }
}

// 세션 생성
POST /api/v1/sessions
Headers: { X-API-Key: 'your-key' }
Body: {
  type: "chat",
  title: "새 세션"
}
Response: {
  success: true,
  data: { id: "session-id", ... }
}

// 세션 상세
GET /api/v1/sessions/{id}
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: { id: "...", messages: [...], ... }
}

// 세션 업데이트
PUT /api/v1/sessions/{id}
Headers: { X-API-Key: 'your-key' }
Body: { title: "업데이트된 제목" }
Response: { success: true }

// 세션 삭제
DELETE /api/v1/sessions/{id}
Headers: { X-API-Key: 'your-key' }
Response: { success: true }
```

## 7. Webhooks Domain

```javascript
// 웹훅 생성
POST /api/v1/webhooks
Headers: { Authorization: 'Bearer token' }
Body: {
  name: "My Webhook",
  url: "https://example.com/webhook",
  events: ["chat.completed", "task.created"]
}
Response: {
  success: true,
  data: { id: 1, ... }
}

// 웹훅 목록
GET /api/v1/webhooks
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { webhooks: [...] }
}

// 웹훅 상세
GET /api/v1/webhooks/{id}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, name: "...", url: "..." }
}

// 웹훅 업데이트
PUT /api/v1/webhooks/{id}
Headers: { Authorization: 'Bearer token' }
Body: { url: "https://example.com/new-webhook" }
Response: { success: true }

// 웹훅 삭제
DELETE /api/v1/webhooks/{id}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }

// 웹훅 테스트
POST /api/v1/webhooks/{id}/test
Headers: { Authorization: 'Bearer token' }
Body: { testEvent: "chat.completed" }
Response: { success: true, data: { delivered: true } }

// 웹훅 로그
GET /api/v1/webhooks/{id}/logs
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { logs: [...] }
}
```

## 8. Config Domain

```javascript
// 설정 저장
POST /api/v1/config
Headers: { Authorization: 'Bearer token' }
Body: {
  key: "value",
  nested: { key: "value" }
}
Response: { success: true }

// 설정 삭제
DELETE /api/v1/config/{key}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }
```

## 9. Report Domain

```javascript
// 보고서 생성
POST /api/v1/report/generate
Headers: { X-API-Key: 'your-key' }
Body: {
  template: "weekly-report",
  data: {
    title: "주간 보고서",
    content: "내용",
    author: "작성자"
  },
  format: "pdf"
}
Response: {
  success: true,
  data: { reportId: "123" }
}

// 보고서 조회
GET /api/v1/report/{id}
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: { id: "123", status: "completed", ... }
}

// 보고서 다운로드
GET /api/v1/report/{id}/download
Headers: { X-API-Key: 'your-key' }
Response: PDF 파일 다운로드

// 보고서 상태
GET /api/v1/report/{id}/status
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: { status: "processing", progress: 50 }
}
```

## 10. Tasks Domain

```javascript
// 작업 목록
GET /api/v1/tasks
Headers: { Authorization: 'Bearer token' }
Query: { status: "pending", limit: 20, offset: 0 }
Response: {
  success: true,
  data: { tasks: [...], total: 50 }
}

// 작업 생성
POST /api/v1/tasks
Headers: { Authorization: 'Bearer token' }
Body: {
  title: "새 작업",
  description: "작업 설명",
  priority: "high",
  dueDate: "2024-12-31"
}
Response: {
  success: true,
  data: { id: 1, ... }
}

// 작업 상세
GET /api/v1/tasks/{id}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, title: "...", status: "pending" }
}

// 작업 업데이트
PUT /api/v1/tasks/{id}
Headers: { Authorization: 'Bearer token' }
Body: { status: "in-progress" }
Response: { success: true }

// 작업 삭제
DELETE /api/v1/tasks/{id}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }

// 작업 상태 변경
PATCH /api/v1/tasks/{id}/status
Headers: { Authorization: 'Bearer token' }
Body: { status: "completed" }
Response: { success: true }

// 작업 할당
POST /api/v1/tasks/{id}/assign
Headers: { Authorization: 'Bearer token' }
Body: { userId: 2 }
Response: { success: true }

// 작업 댓글 목록
GET /api/v1/tasks/{id}/comments
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { comments: [...] }
}

// 댓글 추가
POST /api/v1/tasks/{id}/comments
Headers: { Authorization: 'Bearer token' }
Body: { content: "댓글 내용" }
Response: { success: true }
```

## 11. Projects Domain

```javascript
// 프로젝트 목록
GET /api/v1/projects
Headers: { Authorization: 'Bearer token' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { projects: [...], total: 10 }
}

// 프로젝트 생성
POST /api/v1/projects
Headers: { Authorization: 'Bearer token' }
Body: {
  name: "새 프로젝트",
  description: "프로젝트 설명"
}
Response: {
  success: true,
  data: { id: 1, ... }
}

// 프로젝트 상세
GET /api/v1/projects/{id}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: 1, name: "...", members: [...] }
}

// 프로젝트 업데이트
PUT /api/v1/projects/{id}
Headers: { Authorization: 'Bearer token' }
Body: { name: "업데이트된 이름" }
Response: { success: true }

// 프로젝트 삭제
DELETE /api/v1/projects/{id}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }

// 프로젝트 멤버 목록
GET /api/v1/projects/{id}/members
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { members: [...] }
}

// 멤버 추가
POST /api/v1/projects/{id}/members
Headers: { Authorization: 'Bearer token' }
Body: { userId: 2, role: "editor" }
Response: { success: true }

// 멤버 삭제
DELETE /api/v1/projects/{id}/members/{userId}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }
```

## 12. Context Domain

```javascript
// 컨텍스트 목록
GET /api/v1/context
Headers: { X-API-Key: 'your-key' }
Query: { limit: 20, offset: 0 }
Response: {
  success: true,
  data: { contexts: [...] }
}

// 컨텍스트 생성
POST /api/v1/context
Headers: { X-API-Key: 'your-key' }
Body: {
  name: "새 컨텍스트",
  content: { key: "value" }
}
Response: {
  success: true,
  data: { id: "ctx-123", ... }
}

// 컨텍스트 상세
GET /api/v1/context/{id}
Headers: { X-API-Key: 'your-key' }
Response: {
  success: true,
  data: { id: "ctx-123", content: {...} }
}

// 컨텍스트 업데이트
PUT /api/v1/context/{id}
Headers: { X-API-Key: 'your-key' }
Body: { content: { updated: "value" } }
Response: { success: true }

// 컨텍스트 삭제
DELETE /api/v1/context/{id}
Headers: { X-API-Key: 'your-key' }
Response: { success: true }

// 컨텍스트 내보내기
POST /api/v1/context/{id}/export
Headers: { X-API-Key: 'your-key' }
Body: { format: "json" }
Response: {
  success: true,
  data: { url: "https://..." }
}
```

## 13. Queue Domain

```javascript
// 큐 통계
GET /api/v1/queue/stats
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: {
    pending: 5,
    processing: 2,
    completed: 100,
    failed: 1
  }
}

// 작업 목록
GET /api/v1/queue/jobs
Headers: { Authorization: 'Bearer token' }
Query: { status: "pending", limit: 20 }
Response: {
  success: true,
  data: { jobs: [...] }
}

// 작업 상세
GET /api/v1/queue/jobs/{id}
Headers: { Authorization: 'Bearer token' }
Response: {
  success: true,
  data: { id: "1", status: "completed", ... }
}

// 작업 삭제
DELETE /api/v1/queue/jobs/{id}
Headers: { Authorization: 'Bearer token' }
Response: { success: true }

// 작업 재시도
POST /api/v1/queue/jobs/{id}/retry
Headers: { Authorization: 'Bearer token' }
Response: { success: true, data: { jobId: "2" } }

// 큐 정리
POST /api/v1/queue/purge
Headers: { Authorization: 'Bearer token' }
Body: { status: "completed", olderThan: "2024-01-01" }
Response: { success: true, data: { deleted: 50 } }
```

## WebSocket 연결

실시간 통신을 위한 WebSocket 엔드포인트입니다.

```javascript
const ws = new WebSocket('ws://localhost:5500');

ws.onopen = () => {
  // 인증
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'your-api-key-or-jwt-token'
  }));

  // 채팅
  ws.send(JSON.stringify({
    type: 'chat',
    prompt: 'Hello',
    sessionId: 'session-id'
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);

  if (data.type === 'chat.chunk') {
    // 스트리밍 응답 청크
    console.log(data.content);
  } else if (data.type === 'chat.complete') {
    // 완료
    console.log('Complete:', data.fullResponse);
  } else if (data.type === 'error') {
    // 에러
    console.error('Error:', data.message);
  }
};

ws.onerror = (error) => {
  console.error('WebSocket Error:', error);
};

ws.onclose = () => {
  console.log('WebSocket Connection Closed');
};
```

## 에러 처리

```javascript
try {
  const response = await fetch('http://localhost:5500/api/v1/chat', {
    method: 'POST',
    headers: {
      'X-API-Key': 'your-key',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ prompt: 'Hello' })
  });

  const result = await response.json();

  if (!result.success) {
    throw new Error(result.error?.message || 'API request failed');
  }

  // 성공 응답 처리
  console.log(result.data);
} catch (error) {
  console.error('Error:', error.message);

  // 에러 복구 로직
  if (error.message.includes('INVALID_JSON')) {
    // JSON 형식 수정
  } else if (error.message.includes('UNAUTHORIZED')) {
    // 재인증
  }
}
```

## 일반적인 에러 코드

| 코드 | 설명 | 해결 방법 |
|------|------|----------|
| 400 | 잘못된 요청 | 요청 형식 확인 |
| 401 | 인증 실패 | API 키 또는 토큰 확인 |
| 403 | 권한 없음 | 필요한 권한 확인 |
| 404 | 리소스를 찾을 수 없음 | 엔드포인트 또는 ID 확인 |
| 429 | 요청 속도 초과 | 요청 속도 줄이기 |
| 500 | 서버 내부 오류 | 잠시 후 다시 시도 |

## 속도 제한

- API 키 당 분당 100 요청
- 초당 10 요청 제한
- 초과 시 429 응답

## 일반적인 함정 (Pitfalls)

- 항상 HTTPS를 사용하세요 (프로덕션 환경)
- API 키를 클라이언트 사이드 코드에 노출하지 마세요
- 스트리밍 응답을 처리할 때 적절한 버퍼링을 구현하세요
- 에러 응답을 항상 처리하세요
- 요청 속도 제한을 준수하세요
- WebSocket 연결이 끊어지면 재연결 로직을 구현하세요
- 대용량 파일 업로드 시 청크 업로드를 사용하세요
- JWT 토큰 만료 시 재인증을 구현하세요
- RAG 검색 전에 문서가 초기화되어 있는지 확인하세요
- 비동기 작업은 jobId로 상태를 확인하세요

## 버전별 변경사항

### v1.0.0 (2026-03-19)
- 초기 API 릴리스
- 13개 도메인, 100개 이상의 엔드포인트
- Chat, RAG, Web Search, Report, Tasks, Projects 기능 지원
- JWT 및 API 키 인증 지원
- WebSocket 실시간 통신 지원

## 추가 리소스

- Swagger UI: `http://localhost:5500/api/v1/docs`
- OpenAPI 스펙: `http://localhost:5500/api/v1/docs.json`
- 포트 정보: 프로젝트 루트의 `PORTS.md` 참조
- 통합 테스트: `tests/integration/TEST_SUMMARY.md` 참조
