Feature: Periods and states

#Final - will not change anymore
  @periods_and_states @js
  Scenario: Creating a budget period
    Given I am Hans Ueli
    And there does not exist any budget period yet
    When I navigate to the budget periods
    Then there is an empty budget period line for creating a new one
    When I fill in the name
    And I fill in the start date of the inspection period
    And I fill in the end date of the inspection period
    And I click on save
    Then I see a success message

  # Scenario: Budget period required fields
    # And to create a budget period the following information is needed
    #   |field             |value      |
    #   |name              |text       |
    #   |inspection period |start date |
    #   |budget period     |end date   |
    # And the start date of the inspection period should not be later then the end date of the budget period

#Final - will not change anymore
  @periods_and_states @js
  Scenario: Sorting of budget periods
    Given I am Hans Ueli
    And budget periods exist
    And I navigate to the budget periods
    Then the budget periods are sorted from 0-10 and a-z

#Final - will not change anymore
  @periods_and_states @browser
  Scenario: Deleting a Period
    Given I am Hans Ueli
    And a budget period without any requests exists
    When I navigate to the budget periods
    And I click on 'delete' on the line for this budget period
    Then this budget period disappears from the list
    And this budget period was deleted from the database

#Final - will not change anymore
  @periods_and_states @js
  Scenario: Editing a Budget Period
    Given I am Hans Ueli
    And budget periods exist
    And I navigate to the budget periods
    When I choose a budget period to edit
    And I change the name of the budget period
    And I change the inspection start date of the budget period
    And I change the end date of the budget period
    And I click on save
    Then I see a success message
    And the budget period line was updated successfully
    And the data for the budget period was updated successfully in the database

#Final - will not change anymore
  @periods_and_states @js
  Scenario: Freeze budget period
    Given I am Hans Ueli
    When I set the end date of the budget period equal or later than today
#??# not clear: future end_date means should be still editable
#     Then requests of this budget period can not be edited by admin, requester or inspector

#Final - will not change anymore
  @periods_and_states @js
  Scenario: State "New" - Request Date before Inspection Date
    Given I am Roger
    Given a request exists
    Given the current date is before the inspection date
    Then I see the state "New"

#Final - will not change anymore
  @periods_and_states @js
  Scenario: State "Inspection" - Current Date between Inspection Date and Budget Period End Date
    Given I am Roger
    Given a request exists
    When the current date is between the inspection date and the budget period end date
    Then I see the state "In inspection"
    And I can not modify the request

#Final - will not change anymore
#??# Accepted or Approved ?
  @periods_and_states @js
  Scenario: State "In inspection", "Accepted", "Denied" "Partially Accepted" for requester when budget period has ended
    Given I am Roger
    Given a request exists
    When the current date is after the budget period end date
    And the approved quantity is empty
#??# if the budget inspection phase is over, we display normal states (as before the inspection phase)
#     Then I see the state "In inspection"
#     When the approved quantity is equal to the requested quantity
#     Then I see the state "Approved"
#     When the approved quantity is smaller than the requested quantity
#     And the approved quantity is not equal 0
#     Then I see the state "Partially approved"
#     When the approved quantity is equal 0
#     Then I see the state "Denied"

#Final - will not change anymore
#??# Accepted or Approved ?
  @periods_and_states @js
  Scenario Outline: State "New", "Accepted", "Denied" "Partially Accepted" for inspector
    Given I am Barbara
    Given a request exists
    When the approved quantity is <quantity>
    Then I see the state <state>
    Examples:
      | quantity                                         | state              |
      | empty                                            | New                |
      | equal to the requested quantity                  | Approved           |
      | smaller than the requested quantity, not equal 0 | Partially approved |
      | equal 0                                          | Denied             |

#Final - will not change anymore
  @periods_and_states @js
  Scenario Outline: No Modification or Deletion after Budget End Period date
    Given I am <username>
    Given a request exists
    When the budget period has ended
    Then I can not create any request for the budget period which has ended
    And I can not modify any request for the budget period which has ended
    And I can not delete any requests for the budget period which has ended
    And I can not move a request to a budget period which has ended
    And I can not move a request of a budget period which has ended to another procurement group
    Examples:
      | username  |
      | Barbara   |
      | Hans Ueli |
      | Roger     |

#Final - will not change anymore
#??# merge with Scenario: Sorting of budget periods
  @periods_and_states @js
  Scenario: Overview of Budget Periods
    Given I am Hans Ueli
    Given budget periods exist
#!!# missing required step
    And I navigate to the budget periods
    Then the budget periods are sorted from 0-10 and a-z
#??# total required costs instead?
#    And the amount of requests per budget period is shown
