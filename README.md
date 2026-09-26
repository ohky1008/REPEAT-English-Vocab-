# 단어 오답노트 (실시간 동기화 버전)

컴퓨터에서 추가한 단어가 휴대폰에서도 실시간으로 보이는, 진짜 나만의 웹사이트예요.
아래 단계를 순서대로 따라 하면 끝나요. 전부 무료입니다.

---

## 1. Supabase 프로젝트 만들기 (데이터베이스)

1. https://supabase.com 접속 → 회원가입 (GitHub 계정으로 가입하면 빠름)
2. "New project" 클릭
   - Name: 아무 이름 (예: `vocab-app`)
   - Database Password: 아무 비밀번호 (나중에 안 씀, 그냥 저장해두세요)
   - Region: `Northeast Asia (Seoul)` 추천
3. 프로젝트가 만들어질 때까지 1분 정도 기다려요.

## 2. 데이터베이스 테이블 만들기

1. 왼쪽 메뉴에서 **SQL Editor** 클릭 → **New query**
2. 이 폴더의 `schema.sql` 파일을 열어서 **전체 내용을 복사** → SQL Editor에 붙여넣기
3. 오른쪽 아래 **Run** 클릭
4. "Success. No rows returned" 같은 메시지가 뜨면 완료예요.

## 3. 이메일 로그인 설정 확인

1. 왼쪽 메뉴 **Authentication** → **Providers** → **Email**이 켜져 있는지 확인 (기본값이 켜짐이라 보통 그냥 두면 돼요)
2. **Authentication** → **URL Configuration** 로 이동
   - 지금 단계에서는 비워두고, **5번(배포)**을 마친 뒤 다시 와서 실제 주소를 넣을 거예요. (아래 5-3번 참고)

## 4. API 키를 앱에 붙여넣기

1. 왼쪽 아래 **Project Settings** (톱니바퀴) → **API**
2. **Project URL** 과 **anon public** 키를 복사
3. 이 폴더의 `config.js` 파일을 열어서 아래처럼 채워넣고 저장:

```js
window.APP_CONFIG = {
  SUPABASE_URL: 'https://xxxxxxxx.supabase.co',   // Project URL
  SUPABASE_ANON_KEY: 'eyJhbGciOi...'                // anon public key
};
```

## 5. 무료 호스팅에 배포하기 (Netlify Drop — 가장 쉬움)

1. https://app.netlify.com/drop 접속 (회원가입 없이도 임시 배포는 되지만, 나중에 다시 수정하려면 무료 회원가입을 추천해요)
2. 이 폴더(`english app`) 전체를 그 페이지에 **드래그 앤 드롭**
3. 몇 초 뒤 `https://무작위이름.netlify.app` 같은 주소가 생겨요 — 이게 여러분의 웹사이트 주소예요!
4. (선택) Netlify 계정으로 가입되어 있다면 Site settings에서 주소를 원하는 이름으로 바꿀 수 있어요 (예: `my-vocab.netlify.app`)

배포 후 파일을 수정했다면(예: config.js 갱신), 폴더를 다시 같은 방식으로 드래그해서 올리면 갱신돼요.

### 5-3. Supabase에 배포 주소 등록하기 (중요 — 이거 안 하면 로그인 링크가 안 열려요)

1. 배포된 주소(예: `https://my-vocab.netlify.app`)를 복사
2. Supabase 대시보드 → **Authentication** → **URL Configuration**
   - **Site URL**: 배포 주소를 붙여넣기
   - **Redirect URLs**: 같은 주소를 추가 (Add URL)
3. Save

## 6. 사용하기

1. 컴퓨터와 휴대폰에서 배포된 주소로 접속
2. 이메일 입력 → "로그인 링크 받기"
3. 메일함에서 링크 클릭 → 자동 로그인
4. 이제 컴퓨터에서 단어를 추가하면 휴대폰에도 실시간으로 나타나요 (새로고침 필요 없음)

두 기기 모두 **같은 이메일**로 로그인해야 같은 단어장을 봐요.

---

## 문제 해결

- **"아직 설정이 끝나지 않았어요" 화면만 나와요** → `config.js`에 URL/키를 아직 안 채웠거나, `여기에`라는 글자가 남아있는지 확인
- **로그인 링크를 눌렀는데 에러 페이지가 떠요** → 5-3단계(Redirect URLs 등록)를 안 했을 가능성이 높아요
- **로그인은 되는데 단어가 안 보여요 / 저장이 안 돼요** → SQL Editor에서 `schema.sql`을 제대로 실행했는지 확인 (2단계)
- 화면 위쪽에 빨간 배너로 에러 메시지가 뜨면, 그 메시지가 원인을 알려줘요

## 폴더 구성

- `index.html` — 앱 전체 (수정할 일 거의 없음)
- `config.js` — Supabase 키를 넣는 곳 (유일하게 직접 수정하는 파일)
- `schema.sql` — 데이터베이스 구조 (SQL Editor에 한 번만 실행)
- `server.ps1`, `.claude/launch.json` — 로컬 테스트용 (배포에는 필요 없음, 삭제해도 무방)
