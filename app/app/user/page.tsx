"use client"
// use client는 클라이언트 컴포넌트이지만 prerender를 방지하지는 않는다.
// prerender는 서버에서 빌드할 때 실행된다.
// 서버에서 한 번 실행되어 초기 HTML을 생성한다.

import { useEffect, useState } from "react"

export default function Page() {
  const [data, setData] = useState<{ name: string } | null>(null);
  // 서버의 prerender시 상대경로를 쓸 수 없으므로 useEffect로 처리
  useEffect(() => {
    fetch("/api/me", {
              method: "GET",
              headers: { "Content-Type": "application/json" },
            }).then((res) => res.json()).then(setData);
  }, []);
 
  return (
    <ul>
      hihi
      {data?.name}
    </ul>
  )
}