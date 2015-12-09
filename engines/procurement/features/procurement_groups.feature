Feature: Procurement Groups

  @personas
  Scenario: Creating the Procurement Groups
    Given I am Hans Ueli
    Then I can create one or more procurement groups
    When I create a procurement group the following information is needed
    |field|value|
    |name|text|
    |Inspector|leihs user|
    |Email|text|
    |Budget limits|number|

  Scenario: Sorting of Procurement Groups
    The procurement groups are sorted alphabetically (a-z and 0-10)

  @personas
  Scenario: Editing a procurement group
    Given I am Hans Ueli
    When I edit a procurement group
    Then I can delete an inspector
    And I can add an inspector
    And I can delete a budget limit
    And I can add a budget limit
    And I can change a budget limit
    And I can change the email address
    When the procurement group does not yet have any requests
    Then I can change the name of the procurement group

  @personas
  Scenario: Deleting a procurement group
    Given I am Hans Ueli
    When a procurement group does not yet have any requests
    Then I can delete the procurement group
