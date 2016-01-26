Feature: Procurement Groups

#Final - will not change anymore
  @browser @procurement_groups
  Scenario: Creating the procurement groups
    Given I am Hans Ueli
    And budget periods exist
    And there exists 2 users to become the inspectors
    And I navigate to the groups page
    When I click on the add button
    And I fill in the name
    And I fill in the inspectors' names
    And I fill in the email
    And I fill in the budget limit
    And I click on save
    Then I see a success message
    And the new group was created in the database

# #Final - will not change anymore
#   Scenario: Sorting of Procurement Groups
#     The procurement groups are sorted alphabetically (a-z and 0-10)

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
