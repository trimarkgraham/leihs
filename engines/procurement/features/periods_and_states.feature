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

  # not yet implemented: not sure if already implemented this way
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

  @personas
  Scenario: State "New" and "Inspection" - Request Date before Inspection Date
    Given I am Roger
    Given a request exists
    Given the current date is before the inspection date
    When the approved quantity has not yet ben changed
    Then I see the state "New"
    When the approved quantity has been changed by Barbara
    Then I see the state "inspection"

  @personas
  Scenario: State "Inspection" - Request Date after Inspection Date and before Budget Period End Date
    Given I am Roger
    Given a request exists
    When the current date is between the inspection date and the budget period end date
    Then I see the state "inspection"
    And I can not modify the request

  @personas
  Scenario: State "Accepted", "Denied" "Partially Accepted" for inspector
    Given I am Barbara
    Given a request exists
    When the approved quantity is equal to the requested quantity
    Then I see the state "accepted"
    When the approved quantity is smaller than the requested quantity
    Then I see the state "denied"

  @personas
  Scenario: State "Accepted", "Denied" "Partially Accepted" for requester
    Given I am Roger
    Given a request exists
    Given the current date is later than the budget period end date
    When the approved quantity is equal to the requested quantity
    Then I see the state "accepted"
    When the approved quantity is smaller than the requested quantity
    And the approved quantity is not 0
    Then I see the state "Partially accepted"
    When the approved quantity is set to 0
    Then I see the state "denied"

  @personas
  Scenario: No Modification or Deletion after Budget End Period date
    Given I am Barbara
    Given I am Dani
    Given a request exists
    When the current date is after the budget end period date
    Then I can not modify the request
    And I can not delete the request
