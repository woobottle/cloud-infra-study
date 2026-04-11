export function GET(request: Request) {
  const userId = request.headers.get("x-user-id");
  if (userId) {
    return Response.json({ name: "Test User", userId: 'user-123' });
  }

  return new Response(null, { status: 401 });
}