Feature: Requesters and Organisations

  @personas
  Scenario: Assign a Departement and Organisation Unit
    Given I am Hans Ueli
    Then I can add a requester
    And to each requester I can add a department
    And to each requester I can add an organisation unit
    And typing a department and and organisation is mandatory

  @personas
  Scenario: See the Organisation Tree
    Given I am Hans Ueli
    Then I can view the organisation tree according to the organisations assigned to requester
    And the organisation tree shows the departments with its organisation units

  Scenario: Sorting the Requesters
    The requesters are sorted alphabetically (a-z)

  Scenario: Sorting the Organisations
    The organisations are sorted alphabetically (a-z)
