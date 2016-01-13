Feature: Section Users

  @personas
  Scenario: Add a Requester
    Given I am Hans Ueli
    Then I can add a requester
    And to each requester I need to add a department
    And to each requester I need to add an organisation unit
    And entering a department and an organisation is mandatory
    When the mandatory information is missing
    I receive an error
    And the fields with missing information are marked

  @personas
  Scenario: Delete a Requester
    Given I am Hans Ueli
    Then I can delete a requester

  @personas
  Scenario: Modify a Requester
    Given I am Hans Ueli
    Given a requester exists
    Then I can modify the user name
    And I can modify the department
    And I can modify the organisation unit

  Scenario: Sorting of requester
    Given requesters exist
    Then the requesters are sorted 0-10 and a-z

  @personas
  Scenario: Add an Admin
    Given I am Hans Ueli
    Then I can add an admin
    And the admins are sorted alphabetically from a-z

  @personas
  Scenario: Delete an Admin
      Given I am Hans Ueli
      Then I can delete an admin

  @personas
  Scenario: View the Organisation Tree
    Given I am Hans Ueli
    Then I can view the organisation tree according to the organisations assigned to requester
    And the organisation tree shows the departments with its organisation units
    And the organisations are sorted from 0-10 and a-z
    And inside the organisations the departments are sorted from 0-10 and a-z
