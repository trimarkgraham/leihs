Feature: Periods and states

  @personas
  Scenario: Creating the Periods
    Given I am Hans Ueli
    Then I can create one or more budget periods
    When I create a budget period the following information is needed
    |field|value|
    |name|text|
    |inspection period|start date|
    |budget period|end date|
    And the start date of the inspection period should not be after the end date of the budget period

  Scenario: Sorting of budget periods
  The budget periods are sorted alphabetically (a-z and 0-10)

  @personas
  Scenario: Deleting a Period
    Given I am Hans Ueli
    When a budget period does not yet have any requests
    Then I can delete the budget period

  @personas
  Scenario: Editing a Budget Period
    Given I am Hans Ueli
    When I edit a budget period
    And a budget period does not yet have any requests
    Then I can edit the following information
    |name|
    |inspection period|
    |budget period|
    When I change the start date of the inspection period to later than todays date
    Then Roger can edit his requests
    When I change the start date of the inspection to today
    Then Roger can not edit his request anymore
    When I change the end date of the budget period to today
    Then noone can edit the requests of this budget period anymore
    When I change the end date of the budget period to tomorrow
    And the start of the inspection date has arrived
    Then Barbara and Hans Ueli can edit requests

  @personas
  Scenario: State "New" and "Inspection" - Request Date before Inspection Date
    Given I am Roger
    Given a request exists
    Given the current date is before the inspection date
    Then I see the state "New"

  @personas
  Scenario: State "Inspection" - Request Date after Inspection Date and before Budget Period End Date
    Given I am Roger
    Given a request exists
    When the current date is between the inspection start date and the budget period end date
    Then I see the state "inspection"
    And I can not modify the request

  @personas
  Scenario: State "Accepted", "Denied" "Partially Accepted" for inspector
    Given I am Barbara
    Given a request exists
    When the approved quantity is equal to the requested quantity
    Then I see the state "Accepted"
    When the approved quantity is smaller than the requested quantity
    And the approved quantity is not equal 0
    Then I see the state "Partially Accepted"
    When the approved quantity is is equal 0
    Then I see the state "Denied"

  @personas
  Scenario: Fields shown to Roger after budget period has ended
    Given I am Roger
    Given a request exists
    When the budget period as ended
    Then in addition I see the following information
    |Approved Quantity|
    |Order Size|
    |Inspection Comment|
    |State|
    When the budget period has ended
    Then I see the states as in scenario "State "Accepted", "Denied" "Partially Accepted" for inspector"

  @personas
  Scenario: No Modification or Deletion after Budget End Period date
    Given I am Barbara
    Given I am Hans Ueli
    Given a request exists
    When the budget period has ended
    Then I can not create any request
    And I can not modify any request
    And I can not delete any requests
