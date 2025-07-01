module.exports = {
  // Test environment
  testEnvironment: 'node',
  
  // Test file patterns
  testMatch: [
    '**/test/**/*.test.js',
    '**/test/**/*.spec.js'
  ],
  
  // Test setup files
  setupFilesAfterEnv: [
    '<rootDir>/test/setup.js'
  ],
  
  // Coverage configuration
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  collectCoverageFrom: [
    'src/**/*.js',
    'src/**/*.cbl',
    '!src/**/*.test.js',
    '!src/**/*.spec.js',
    '!test/**/*',
    '!**/node_modules/**'
  ],
  
  // Module name mapping for COBOL files
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
    '^@test/(.*)$': '<rootDir>/test/$1'
  },
  
  // Test timeout
  testTimeout: 30000,
  
  // Verbose output
  verbose: true,
  
  // Clear mocks between tests
  clearMocks: true,
  
  // Restore mocks between tests
  restoreMocks: true,
  
  // Test directories
  testPathIgnorePatterns: [
    '/node_modules/',
    '/bin/',
    '/uploads/'
  ],
  
  // Coverage thresholds
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70
    }
  },
  
  // Projects for different test types
  projects: [
    {
      displayName: 'unit',
      testMatch: ['<rootDir>/test/unit/**/*.test.js'],
      setupFilesAfterEnv: ['<rootDir>/test/setup-unit.js']
    },
    {
      displayName: 'integration',
      testMatch: ['<rootDir>/test/integration/**/*.test.js'],
      setupFilesAfterEnv: ['<rootDir>/test/setup-integration.js']
    },
    {
      displayName: 'e2e',
      testMatch: ['<rootDir>/test/e2e/**/*.test.js'],
      setupFilesAfterEnv: ['<rootDir>/test/setup-e2e.js']
    }
  ]
}; 