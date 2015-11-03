Feature: Overview for requester

  @personas
  Scenario: View requests of current budget phase
    Given I am Roger
    Given a request for the current budget phase exists
    Given a request for a past budget phase exists
    Then I see my requests for the current budget phase
    And I see my requests for a past budget phase

  Scenario: Structure of overview
    Given a request exists
    Then the overview shows the request in the following structure
    |Highest Hierarchie|Departement|Services|
    |Second Hierarchie|Organisation Unit|ITZ|
    |Third Hierarchie|request line|Laptop|

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

  Scenario: Showing Total on Overview
    Given the overview shows more than one request line
    When the approved quantity of a request line is not set
    Then the total of this request line is calculated by "requested quantity x price"
    When the approved quantity is set
    Then the total is calculated by "order quantity x price"
    And the totals of all shown request lines are summed up

  @personas
  Scenario: Filtering possibilities
    Given I am Roger
    Then I can filter according to following attributes
    |Budget Phase|
    |Requester Priority|
    |Procurement Group|
    |State|
    And I search items by typing the item name
    And by default the current budget phase is selected
    And by default all priorities are selected
    And by default all procurement groups are selected
    And by default all states are selected

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
