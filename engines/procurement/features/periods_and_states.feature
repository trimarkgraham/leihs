Feature: Periods and states

  @personas
  Scenario: Creating the Periods
    Given I am Dani
    Then I can create one or more budget periods
    When I create a budget period the following information is needed
    |field|value|
    |name|text|
    |inspection period|start date|
    |budget period|end date|

  @personas
  Scenario: Deleting a Period
    Given I am Dani
    When a budget period does not yet have any requests
    Then I can delete the budget period

  @personas
  Scenario: Editing a Budget Period
    Given I am Dani
    When I edit a budget period
    ??

  @personas
  Scenario: Request Date before Budget Period End Date
    Given I am Roger
    When I create a request
    And the create date is before the end date of the budget period
    Then the request is assigned to the current budget period
