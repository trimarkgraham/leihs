Feature: Overview for requester

  # not yet implemented
  @personas
  Scenario: View requests
    Given I am Roger
    Then I see my requests sorted according to the budget periods and procurement groups

  # not yet implemented
  Scenario: Structure of overview
    Given a request exists
    Then the overview shows the request in the following structure: 1st Budget Period, 2nd Procurement Group, 3rd Articles

  # not yet implemented
  Scenario: Visible Information of current requests
    Given a request exists
    Then the overview shows at least the following information of a request
    |Department|
    |Organisation Unit|
    |Requested Amount|
    |Approved Amount|
    |Item Name|
    |Procurement Group|
    |Requester Priority|
    |State|
    |Total CHF|on request line
    |Total CHF|overall on page

  # not yet implemented
  Scenario: Showing Total on Overview
    Given the overview shows more than one request line
    When the approved quantity of a request line is not set
    Then the total of this request line is calculated by "requested quantity x price"
    When the approved quantity is set
    Then the total is calculated by "order quantity x price"
    And the totals of all shown request lines are summed up

  # not yet implemented
  @personas
  Scenario: Filtering possibilities
    Given I am Roger
    Then I can filter according to following attributes
    |Budget Period|
    |Requested Priority|
    |Procurement Group|
    |State|
    And I search items by typing the item name
    And by default the current budget phase is selected
    And by default all priorities are selected
    And by default all procurement groups are selected
    And by default all states are selected

  # not yet implemented
  @personas
  Scenario: Editable Information in Overview
    Given I am Roger
    Given a request exists
    When the inspection date for the current budget period has not yet been reached
    Then I can edit the following information directly in the overview
    |Procurement Group|
    |Amount|
    |Price|
    And I can edit all other editable fields of the request line by editing the request line
