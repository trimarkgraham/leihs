Feature: Description of roles

  @roles @browser
  Scenario: Role Requester
    Given I am Roger
    And a request exists
    And a group mail exists
    And I can manage my request
    And I can export the data
    And I can write an email to a group
    And I can move requests to other budget periods
    And I can move requests to other groups
    And I can not inspect requests
    And I can not add requester
    And I can not add administrators
    And I can not add groups
    And I can not add budget periods
    And I can not manage templates
    And I can not create requests for another person
    And I can not see budget limits

  @roles @browser
  Scenario: Role Inspector
    Given I am Barbara
    And a budget period exists
    And a group exists
    And I am inspector of this group
    And the group has a mail
    And the group has a budget limit
    And a request for my own group exists
    And I can manage this request
    And I can export the data
    And I can write an email to a group
    And I can move requests of my own group to other budget periods
    And I can move requests of my own group to other groups
    And I can inspect requests of my own group
    And I can not create a request
    And I can create requests for my group for another person
    And I can manage templates of my group
    And I can not add requester
    And I can not add administrators
    And I can not add groups
    And I can not add budget periods
    And I can see all budget limits

  @roles @browser
  Scenario: Role Administrator
    Given I am Hans Ueli
    Then I can create a budget period
    And I can create a group
    And I can add requesters
    And I can add Admins
    And I can not a request created by myself exists
    And a request created by someone else exists
    And I can manage my request
    And I can read only the request of someone else
    And I can export all data
    And I can write an email to a group
    And I can not move requests to other budget periods
    And I can not  move requests to other groups
    And I can not inspect requests of my own group
    And I can not not create requests for another person
    And I can not manage templates of groups

   @roles
   Scenario: Role leihs Admin
     Given I am Gino
     Then I can assign the first Admin of the procurement
