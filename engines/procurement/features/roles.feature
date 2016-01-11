Feature: Describing the roles

  @personas
  Scenario: Role Requester
    Given I am Roger
    Then I can manage my requests

  @personas
  Scenario: Role Inspector
    Given I am Barbara
    Then I can create requests for myself
    And I can create requests for other users
    And I can manage my own requests
    And I can manage requests of the procurement group I am responsible for
    And I can create templates of the procurement group I am responsible for

  @personas
  Scenario: Role Admin
    Given I am Hans Ueli
    Then I can manage budget periods
    And I can manage procurement groups
    And I can manage users
    And I can manage Admins
    And I can manage organisations

  @personas
  Scenario: Role leihs Admin
    Given I am Gino
    Then I can assign the first Admin of the procurement
