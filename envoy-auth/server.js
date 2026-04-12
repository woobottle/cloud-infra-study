// const express = require('express')
// const app = express();

// // 모든 요청을 받는 핸들러
// // Envoy ext_authz는 원본 요청의 메서드/경로/헤더를 그대로 보네요
// app.use((req, res) => {
//   const authHeader = req.headers['authorization']

//   // 1. authorization 헤더 검사
//   if (!authHeader) {
//     return res.status(401).end()
//   }

//   // 2. Bearer 토큰 추출
//   const token = authHeader.split(' ')[1]
//   if (!token) {
//     return res.status(401).end()
//   }

//   try {
//   // 3. 토큰 -> userId 매핑
//   const userId = tokenToUserId(token)
//   // 4. 성공: res.set('x-user-id', userId) + 200 응답
//   return res.set('x-user-id', userId).status(200).end()
//   } catch(e) {
//     // 5. 실패: 403 응답 
//     return res.status(403).end()  
//   }
// })

const express = require('express')
const app = express();

app.use((req, res) => {
    console.log('=== [envoy-auth] 요청 수신 ===')
    console.log('Method:', req.method, 'Path:', req.path)
    console.log('받은 헤더:', JSON.stringify(req.headers, null, 2))

    const authHeader = req.headers['authorization']

    if (!authHeader) {
      console.log('=> 401: authorization 헤더 없음')
      return res.status(401).end()
    }

    const token = authHeader.split(' ')[1]
    if (!token) {
      console.log('=> 401: Bearer 토큰 없음')
      return res.status(401).end()
    }

    try {
      const userId = tokenToUserId(token)
      console.log('=> 200: x-user-id 헤더 추가:', userId)
      return res.set('x-user-id', userId).status(200).end()
    } catch(e) {
      console.log('=> 403: 토큰 변환 실패')
      return res.status(403).end()
    }
  })

app.listen(3001, () => {
  console.log('envoy-auth listening on :3001')
})

const tokenToUserId = (token) => {
 return token.replace('user-', '') 
}

// cloud-infra-study git:(step4/envoy-auth) ✗ kubectl logs -l app=envoy-auth -c envoy-auth --tail=20
// envoy-auth listening on :3001
// envoy-auth listening on :3001
// === [envoy-auth] 요청 수신 ===
// Method: GET Path: /api/me
// 받은 헤더: {
//   "host": "acc83c4767e414ad28016c14bc93f802-986420423.ap-northeast-2.elb.amazonaws.com",
//   "content-length": "0",
//   "authorization": "Bearer user-123",
//   "x-envoy-internal": "true",
//   "x-envoy-expected-rq-timeout-ms": "600000"
// }
// => 200: x-user-id 헤더 추가: 123