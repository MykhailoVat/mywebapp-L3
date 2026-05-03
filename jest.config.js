export default {
  testEnvironment: "node",
  testMatch: ["**/auto_tests/**/*.test.js"],
  transform: {},
  //extensionsToTreatAsEsm: [".js"],
  testTimeout: 10000,
  detectOpenHandles: true,
  verbose: true,
  testPathIgnorePatterns: ["/node_modules/"],
  coverageDirectory: "auto_tests/coverage",
  coverageThreshold: {
    global: {
      branches: 40,
      functions: 40,
      lines: 40,
      statements: 40
    },
  }
};