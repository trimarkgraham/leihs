Feature: Describing the roles

  @personas
  Scenario: Role Requester
    Given I am Roger
    Then I can manage my requests

  # not yet implemented: create a request for someone else
  @personas
  Scenario: Role Inspector
    Given I am Barbara
    Then I can create requests for myself
    Then I can create requests for other users
    And I can manage my requests
    And I can manage requests of the procurement group I am responsible for
    And I can create templates
    And I can add other inspectors to a procurement group I am responsible for

  @personas
  Scenario: Role Admin
    Given I am Dani
    Then I can manage budget periods
    And I can manage procurement groups
    And I can manage requesters
    And I can manage Admins
    And I can manage organisations

  @personas
  Scenario: Role leihs Admin
    Given I am Gino
    Then I can assign the first Admin of the procurement
