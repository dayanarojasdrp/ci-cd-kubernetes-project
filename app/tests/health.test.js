const request = require("supertest");
const app = require("../src/server");

describe("CI/CD Kubernetes API", () => {
  test("GET /health should return 200 and status ok", async () => {
    const response = await request(app).get("/health");

    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual({ status: "ok" });
  });

  test("GET /version should return app version information", async () => {
    const response = await request(app).get("/version");

    expect(response.statusCode).toBe(200);
    expect(response.body).toHaveProperty("app", "ci-cd-kubernetes-app");
    expect(response.body).toHaveProperty("version", "1.0.0");
    expect(response.body).toHaveProperty("environment", "local");
  });
});
