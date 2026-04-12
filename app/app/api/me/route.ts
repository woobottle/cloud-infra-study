// export function GET(request: Request) {
//   const userId = request.headers.get("x-user-id");
//   if (userId) {
//     return Response.json({ name: "Test User", userId: 'user-123' });
//   }

//   return new Response(null, { status: 401 });
// }

import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const userId = request.headers.get("x-user-id");

  return NextResponse.json({
    userId,
    name: "Test User",
    role: "member"
  })
}

