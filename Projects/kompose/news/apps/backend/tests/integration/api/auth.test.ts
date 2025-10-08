import { describe, it, expect } from "vitest"
import { request } from "@helpers/request"

describe("Auth", () => {
  it("Should return 401 without API Key", async () => {
    const response = await request.get("/api/subscribers")
    expect(response.status).toBe(401)
  })

  it("Should return 401 with invalid API Key", async () => {
    const response = await request
      .get("/api/subscribers")
      .set("x-api-key", "invalid")
    expect(response.status).toBe(401)
  })
})
