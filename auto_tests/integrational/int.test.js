import request from "supertest";
import app from "../../src/server/app.js";
import pool from "../../src/repositories/pool.js";

// 🔥 очищаємо БД перед кожним тестом
beforeEach(async () => {
    await pool.query('TRUNCATE TABLE tasks RESTART IDENTITY CASCADE');
});

// 🔥 закриваємо конекшн після всіх тестів
afterAll(async () => {
    await pool.end();
});

describe("Health endpoints", () => {

    test("GET /health/alive should return 200", async () => {
        const res = await request(app).get("/health/alive");

        expect(res.status).toBe(200);
        expect(res.text).toBe("app alive");
    });

    test("GET /health/ready should return 200 when DB is up", async () => {
        const res = await request(app).get("/health/ready");

        expect(res.status).toBe(200);
    });
});

describe("Base endpoint", () => {

    test("GET / should return HTML", async () => {
        const res = await request(app)
            .get("/")
            .set("Accept", "text/html");

        expect(res.status).toBe(200);
        expect(res.text).toContain("MyWebApp API");
    });
});

describe("Tasks API", () => {

    test("POST /tasks -> create task (JSON)", async () => {
        const res = await request(app)
            .post("/tasks")
            .set("Accept", "application/json")
            .send({ title: "test task" });

        expect(res.status).toBe(201);
        expect(res.body.title).toBe("test task");
        expect(res.body.status).toBe("NEW");
    });

    test("GET /tasks -> should return list", async () => {
        await request(app)
            .post("/tasks")
            .send({ title: "task1" });

        const res = await request(app)
            .get("/tasks")
            .set("Accept", "application/json");

        expect(res.status).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);
        expect(res.body.length).toBe(1);
    });

    test("POST /tasks/:id/done -> mark task as done", async () => {
        const createRes = await request(app)
            .post("/tasks")
            .send({ title: "task1" });

        const id = createRes.body.id;

        const doneRes = await request(app)
            .post(`/tasks/${id}/done`)
            .set("Accept", "application/json");

        expect(doneRes.status).toBe(200);
        expect(doneRes.body.status).toBe("DONE");
    });

    test("POST /tasks/:id/done -> 404 if not found", async () => {
        const res = await request(app)
            .post("/tasks/999/done")
            .set("Accept", "application/json");

        expect(res.status).toBe(404);
    });

    test("POST /tasks -> validation error", async () => {
        const res = await request(app)
            .post("/tasks")
            .set("Accept", "application/json")
            .send({ title: "" });

        expect(res.status).toBe(400);
    });
});