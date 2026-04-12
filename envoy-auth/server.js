const express = require('express')
const app = express();

// 모든 요청을 받는 핸들러
// Envoy ext_authz는 원본 요청의 메서드/경로/헤더를 그대로 보네요
app.use((req, res) => {
  const authHeader = req.headers['authorization']

  // 1. authorization 헤더 검사
  if (!authHeader) {
    return res.status(401).end()
  }

  // 2. Bearer 토큰 추출
  const token = authHeader.split(' ')[1]
  if (!token) {
    return res.status(401).end()
  }

  try {
  // 3. 토큰 -> userId 매핑
  const userId = tokenToUserId(token)
  // 4. 성공: res.set('x-user-id', userId) + 200 응답
  return res.set('x-user-id', userId).status(200).end()
  } catch(e) {
    // 5. 실패: 403 응답 
    return res.status(403).end()  
  }
})

app.listen(3001, () => {
  console.log('envoy-auth listening on :3001')
})

const tokenToUserId = (token) => {
 return token.replace('user-', '') 
}