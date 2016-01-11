Feature: Templates

  @personas
  Scenario: Creating a Template Group for a Procurement Group
    Given I am Barbara
    Then I can create a template category for a procurement group I am responsible for
    And within the template category I can set the following information
    |Article|
    |Price|
    |Supplier|
    |article nr./manufacturer nr|

  @personas
  Scenario: Deleting a Category
    Given I am Barbara
    Then I can delete the whole Category

  @personas
  Scenario: Deleting an Article
    Given I am Barbara
    Then I can delete a whole line in a category

  @personas
  Scenario: Deleting information
    Given I am Barbara
    Then I can delete existing information of the fields
    |Price|
    |Supplier|
    |article nr./manufacturer nr|

  @personas
  Scenario: Edit information
    Given I am Barbara
    Then I can edit existing information of the fields
    |Category|
    |Article|
    |Price|
    |Supplier|
    |article nr./manufacturer nr.|
