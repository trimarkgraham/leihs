Feature: Templates

  Scenario: Definition of templates
    When a template is created
    Then this template belongs to a procurement group
    And a template contains categories
    And a category contains articles

  @personas
  Scenario: Information in a category
  Given I am Barbara
    Then I can give a category a name
    And within the category I can add articles
    And an article contains the following information
    |Article|
    |Article nr./Manufacturer nr|
    |Price|
    |Supplier|

  @personas
  Scenario: Deleting a Category
    Given I am Barbara
    Then I can delete the whole Category

  @personas
  Scenario: Deleting an Article
    Given I am Barbara
    Then I can delete an article of a category

  @personas
  Scenario: Deleting information
    Given I am Barbara
    Then I can delete existing information of the fields
    |Article nr./Manufacturer nr|
    |Price|
    |Supplier|

  @personas
  Scenario: Modify information
    Given I am Barbara
    Then I can modify existing information of the fields
    |Category|
    |Article|
    |Article nr./Manufacturer nr|
    |Price|
    |Supplier|

  @personas
  Scenario: Mandatory fields
    Given I am Barbara
    When I create a category
    Then the following fields are mandatory
    |Category|
    |Article|
    When I save the template without entering the mandatory information
    Then I receive an error message
    And the fields with missing information are marked

  Scenario: Sorting
    Given categories exist
    Given articles in categories exist
    Then the categories are sorted 0-10 and a-z
    And the articles inside a category are sorted 0-10 and a-z
