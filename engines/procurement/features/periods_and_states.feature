Feature: Periods and states

  @personas
  Scenario: Creating the Periods
    Given I am Hans Ueli
    Then I can create one or more budget periods
    And to create a budget period the following information is needed
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
    Then I can edit the following information
    |name|
    |inspection period|
    |budget period|
    When I set the start date of the inspection period to later than todays date
    Then all users can edit the requests
    When I set the start date of the inspection to today
    Then Roger can not edit his requests
    When I set the end date of the budget period to today
    Then no user can edit the requests of this budget period

  @personas
  Scenario: State "New" - Request Date before Inspection Date
    Given I am Roger
    Given a request exists
    Given the current date is before the inspection date
    Then I see the state "New"

  @personas
  Scenario: State "Inspection" - Current Date between Inspection Date and Budget Period End Date
    Given I am Roger
    Given a request exists
    When the current date is between the Inspection Date and the Budget Period End Datea
    Then I see the state "Inspection"
    And I can not modify the requests

  @personas
  Scenario: State "Inspection" - Current Date after Budget Period End Date
    Given I am Roger
    Given a request exists
    When the current date is after the Budget Period End Date
    Then I see the state "New", "Partially approved", "Approved", "Denied"

  @personas
  Scenario: State "Accepted", "Denied" "Partially Accepted" for inspector
    Given I am Barbara
    Given a request exists
    When the approved quantity is empty
    Then I see the state "New"
    When the approved quantity is equal to the requested quantity
    Then I see the state "Accepted"
    When the approved quantity is smaller than the requested quantity
    And the approved quantity is not equal 0
    Then I see the state "Partially Accepted"
    When the approved quantity is equal 0
    Then I see the state "Denied"

  @personas
  Scenario: Additional Fields shown to Roger after budget period has ended
    Given I am Roger
    Given a request exists
    When the budget period as ended
    Then in addition I see the following information
    |Approved Quantity|
    |Inspection Comment|

  @personas
  Scenario: No Modification or Deletion after Budget End Period date
    Given I am Barbara
    Given I am Hans Ueli
    GIven I am Roger
    Given a request exists
    When the budget period has ended
    Then I can not create any request for the budget period which has ended
    And I can not modify any request for the budget period which has ended
    And I can not delete any requests for the budget period which has ended
    And I can not move a request to a budget period which has ended
