const express = require("express");

const app = express();

const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || "ci-cd-kubernetes-app";
const APP_VERSION = process.env.APP_VERSION || "1.0.0";
const APP_ENV = process.env.APP_ENV || "local";

app.get("/", (req, res) => {
  res.status(200).json({
    message: "CI/CD Kubernetes demo API",
    app: APP_NAME,
    version: APP_VERSION,
    environment: APP_ENV
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/ready", (req, res) => {
  res.status(200).json({ ready: true });
});

app.get("/version", (req, res) => {
  res.status(200).json({
    app: APP_NAME,
    version: APP_VERSION,
    environment: APP_ENV
  });
});

if (require.main === module) {
  app.listen(PORT, "0.0.0.0", () => {
    console.log(`${APP_NAME} listening on port ${PORT}`);
  });
}

module.exports = app;
