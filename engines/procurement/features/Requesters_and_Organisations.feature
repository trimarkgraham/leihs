Feature: Requesters and Organisations

  @personas
  Scenario: Assign a Departement and Organisation Unit
    Given I am Hans Ueli
    Then I can add a requester
    And to each requester I can type a department
    And to each requester I can type an organisation unit
    And typing a department and and organisation is mandatory

  @personas
  Scenario: See the Organisation Tree
    Given I am Hans Ueli
    Given I am Barbara
    Then I can view the organisation tree according to the organisations assign to procurement requesters
    And the organisation tree shows the departments with its organisation units

  Scenario: Sorting of Organisations
    The organisations are sorted alphabetically (a-z)

  Scenario: Sorting of Requesters
    The requesters are sorted alphabetically (a-z)
