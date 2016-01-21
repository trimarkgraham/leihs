Feature: section "My requests"

  @personas
  Scenario: What to see in section "My requests"
    Given I am Roger
    When I enter the section "My requests"
    Then I see all budget periods
    And the current budget period is marked in green
    And the current budget period is expanded
    And I see the total price of all requests of a budget period
    When I enter a budget period
    Then I see all procurement groups
    And for each procurement group I see the amount of requests per status
    And for each procurement group I see the total price of all requests of a procurement group
    When I enter a procurement group
    Then I see all my requests of this specific group

  @personas
  Scenario: CSV Export
    Given I am Roger
    When I enter "My requests"
    Then I can export all requests of a budget period
