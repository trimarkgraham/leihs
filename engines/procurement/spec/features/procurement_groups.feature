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
  @procurement_groups @js
  Scenario: Sorting of Procurement Groups
    Given I am Hans Ueli
    And 3 procurement groups exist
    And I navigate to the groups page
    Then the procurement groups are sorted alphabetically

# #Final - will not change anymore
#   @personas
#   Scenario: Editing a procurement group
#     Given I am Hans Ueli
#     When I edit a procurement group
#     Then I can delete an inspector
#     And I can add an inspector
#     And I can delete a budget limit
#     And I can add a budget limit
#     And I can change a budget limit
#     And I can change the email address

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
