Feature: Procurement Groups

#Final - will not change anymore
  @personas
  Scenario: Creating the Procurement Groups
    Given I am Hans Ueli
    Then I can create one or more procurement groups
    And a procurement group can hold the following information
    |field|value|
    |name|text|
    |Inspectors|leihs user|
    |Email|text|
    |Budget limits|number|

#Final - will not change anymore
  Scenario: Sorting of Procurement Groups
    The procurement groups are sorted alphabetically (a-z and 0-10)

#Final - will not change anymore
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

#Final - will not change anymore
  @personas
  Scenario: Deleting a procurement group
    Given I am Hans Ueli
    When a procurement group does not yet have any requests
    Then I can delete the procurement group

#Final - will not change anymore
  Scenario: Overview of the procurement groups
    Given procurement groups exist
    Then the overview shows the names of the procurement groups
    And the overview shows the Inspectors per procurement group
    And the overview shows the email per procurement group

#Final - will not change anymore
  @personas
  Scenario: Mandatory fields
    Given I am Hans Ueli
    When I create a procurement group
    Then the group name is mandatory
    And the mandatory field is marked red
    When I save the request without entering the mandatory information
    Then I receive an error message
