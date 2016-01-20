Feature: Smoke test

  @browser
  Scenario: Check test setup
    Then it should work with Roger
    And it should work with Hans Ueli
    And it should work with Gino

  Scenario: Circular redirect
    Then it should work with Barbara
