Feature: Templates

  @personas
  Scenario: Creating a Template Group for a Procurement Group
    Given I am Barbara
    Then I can create a template group for a procurement group I am responsible for

  Scenario: Creating a template for my template group
    Given I am Barbara
    Then I can create a template for a procurement group I am responsible for

  @personas
  Scenario: Content of template
    Given I am Barbara
    When I create a template
    Then I set the following information
    |Template Group|
    |Budget Period|
    |Procurement Group|
    |Template Group|
    |Item Name|
    |Price|
    And choosing the template group is not mandatory

  @personas
  Scenario: Defining the model
    Given I am Barbara
    When I create a template
    Then I can select the model name from a list of existing models
    Or I can type a new model name
