Feature: Templates

#Final - will not change anymore
  Scenario: Create a Template Category
    Given I am Barbara
    And I am responsible for one group
    When I navigate to the templates page
    Then there is an empty category line for creating a new category
    When I enter the category name
    And I click on save
    Then I see a success message
    And the category is saved to the database

    Scenario: Create an Template Article
      Given I am Barbara
      And a template category exists
      When I navigate to the templates page
      And I enter an article name
      And I enter the article/suppliernr.
      And I enter the price
      And I enter the supplier
      And I click on save
      Then I see a success message
      And the data entered is saved to the database

    Scenario: Deleting a Template Category
      Given I am Barbara
      And a template category exists
      And the template category contains articles
      When I navigate to the templates page
      And I delete the template category
      Then the template category is marked red
      When I click on save
      Then I see a success message
      And the deleted template category is deleted from the database

    #will not change anymore
    Scenario: Deleting an Article
      Given I am Barbara
      And a template category exists
      And the template category contains an article
      When I navigate to the templates page
      And I edit a category
      And I delete an article from the category
      Then the article of the category is marked red
      When I click on save
      Then I see a success message
      And the category articles are deleted from the database

    Scenario: Editing a Template
      Given I am Barbara
      And a template category exists
      And the template category has one article
      When I navigate to the templates page
      And I modify the category name
      And I modify the article name
      And I modify the article/suppliernr.
      And I modify the price
      And I modify the supplier
      And I click on save
      Then I see a success message
      And the data modified is saved to the database

##will not change anymore
  @templates @browser
  Scenario: Deleting information of some fields of an article
    Given I am Barbara
    And a template category exists
    And the template category has one article
    And the article name is filled
    And the article/suppliernr. is filled
    And the price is filled
    And the supplier is filled
    When I delete the article/suppliernr.
    And I delete the price
    And I delete the supplier
    And I click on save
    Then I see a success message
    And the deleted data is deleted from the database

  Scenario: Sorting of categies and articles
    Given I am Barbara
    And several template categories exist
    And several articles in categories exist
    When I navigate to the templates page
    Then the categories are sorted 0-10 and a-z
    And the articles inside a category are sorted 0-10 and a-z
