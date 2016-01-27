Feature: Procurement Groups

#Final - will not change anymore
  @procurement_groups @browser
  Scenario: Creating the procurement groups
    Given I am Hans Ueli
    And a budget period exist
    And there exists 2 users to become the inspectors
    And I navigate to the groups page
    When I click on the add button
    And I fill in the name
    And I fill in the inspectors' names
    And I fill in the email
    And I fill in the budget limit
    And I click on save
    Then I am redirected to the groups index page
    And the new group appears in the list
    And the new group was created in the database

#Final - will not change anymore
  @procurement_groups @browser
  Scenario: Sorting of Procurement Groups
    Given I am Hans Ueli
    And 3 procurement groups exist
    And I navigate to the groups page
    Then the procurement groups are sorted alphabetically

#Final - will not change anymore
  @procurement_groups @browser
  Scenario: Editing a procurement group
    Given I am Hans Ueli
    And there exists a procurement group
    And there exists 2 budget limits for the procurement group
    And the procurement group has 2 inspectors
    And there exists an extra budget period
    When I navigate to the group's edit page
    And I modify the name
    And I delete an inspector
    And I add an inspector
    And I modify the email address
    And I delete a budget limit
    And I add a budget limit
    And I modify a budget limit
    And I click on save
    Then I see that the all the information of the procurement group was updated correctly
    And all the information of the procurement group was successfully updated in the database

# #Final - will not change anymore
#   @personas
#   Scenario: Deleting a procurement group
#     Given I am Hans Ueli
#     When a procurement group does not yet have any requests
#     Then I can delete the procurement group

# #Final - will not change anymore
#   Scenario: Overview of the procurement groups
#     Given procurement groups exist
#     Then the overview shows the names of the procurement groups
#     And the overview shows the Inspectors per procurement group
#     And the overview shows the email per procurement group

# #Final - will not change anymore
#   @personas
#   Scenario: Mandatory fields
#     Given I am Hans Ueli
#     When I create a procurement group
#     Then the group name is mandatory
#     And the mandatory field is marked red
#     When I save the request without entering the mandatory information
#     Then I receive an error message
