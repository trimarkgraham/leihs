Feature: Section Users

#Final - will not change anymore
  @users_and_organisations @js
  Scenario: Add a requester
    Given I am Hans Ueli
    And there does not exist any requester yet
    But there exists a user to become a requester
    When I navigate to the users page
    Then there is an empty requester line for creating a new one
    When I fill in the requester name
    And I fill in the department
    And I fill in the organization
    And I click on save
    Then I see a success message
    And the new requester was created in the database

#Final - will not change anymore
  @users_and_organisations @js
  Scenario Outline: Requester required fields
    Given I am Hans Ueli
    And there does not exist any requester yet
    But there exists a user to become a requester
    When I navigate to the users page
    Then there is an empty requester line for creating a new one
    When I fill in the <1st field>
    And I fill in the <2nd field>
    And I click on save
    And the "<3rd field>" is marked red
    And the new requester has not been created

    Examples:
      | 1st field      | 2nd field    | 3rd field      |
      | requester name | department   | organization   |
      | requester name | organization | department     |
      | department     | organization | requester name |

#Final - will not change anymore
  @users_and_organisations @js
  Scenario: Delete a requester
    Given I am Hans Ueli
    And there exists a requester
    When I navigate to the users page
    And I click on the minus button on the requester line
    And the requester line is marked for deletion
    When I click on save
    Then the requester disappears from the list
    And the requester was successfully deleted from the database

  @users_and_organisations @js
  Scenario: Modify a requester
    Given I am Hans Ueli
    And there exists a requester
    And there exists an extra user
    And I navigate to the users page
    When I modify the requester name to be that of the extra user
    And I modify the department
    And I modify the organization
    And I click on save
    Then I see a success message
    And I see the successful changes on the page
    And the requester information was changed successfully in the database

#Final - will not change anymore
  @users_and_organisations @js
  Scenario: Sorting of requester
#??# who? where?
#    Given requesters exist
#    Then the requesters are sorted 0-10 and a-z

#Final - will not change anymore
  @users_and_organisations @js
  Scenario: Add an Admin
    Given I am Hans Ueli
    Then I can add an admin
    And the admins are sorted alphabetically from a-z

#Final - will not change anymore
  @users_and_organisations @js
  Scenario: Delete an Admin
    Given I am Hans Ueli
    Then I can delete an admin

#Final - will not change anymore
  @users_and_organisations @browser
  Scenario: View the Organisation Tree
    Given I am Hans Ueli
    Then I can view the organisation tree according to the organisations assigned to requester
    And the organisation tree shows the departments with its organisation units
    And the organisations are sorted from 0-10 and a-z
    And inside the organisations the departments are sorted from 0-10 and a-z
