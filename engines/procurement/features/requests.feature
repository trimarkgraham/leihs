Feature: requests (state-behaviour described in seperate feature-file)

  @personas
  Scenario: Create a request
    Given I am Roger
    When I create a request
    Then I chose the procurement group
    And I chose the budget period
    And I set the following information
    |Article|
    |Article nr./manufacturer nr.|
    |New/Replacement|
    |Quantity|
    |Price|
    |Priority|
    |Replacement / New|
    |Supplier|
    |Motivation|
    |Receiver|
    |Point of Delivery|
    |Attachment|
    |State|

  @personas
  Scenario: Editable Fields
    Given I am Roger
    When I create a Request
    Then I can modify the following fields
    |Article|
    |Article nr./manufacturer nr.|
    |New/Replacement|
    |Quantity|
    |Price|
    |Priority|
    |Replacement / New|
    |Supplier|
    |Motivation|
    |Receiver|
    |Point of Delivery|
    |Attachment|

  @personas
  Scenario: Mandatory fields
    Given I am Roger
    When I create a request
    Then the following fields are mandatory
    |Article|
    |New/Replacement|
    |Quantity|
    |Priority|
    |Replacement / New|
    |Motivation|
    And I see which fields are mandatory

  @personas
  Scenario: Mandatory fields
    Given I am Roger
    When I have not filled out all mandatory fields
    And I save this request
    Then I receive an information, that information is missing

  @personas
  Scenario: Chose from a Category
    Given I am Roger
    When I chose an article from a category
    Then the following fields are prefilled
    |Article|
    |Quantity|
    |Price|
    |Supplier|
    |Article nr./Manufacturer nr|
    And the quantity is set to 1

  @personas
  Scenario: Chosing an existing or non existing Model
    Given I am Roger
    When I create a request
    Then I can choose a model by typing the model name
    When the model name does not exist
    Then the entered model name is saved

  @personas
  Scenario: Delete a Request
    Given I am Roger
    Then I can delete my request

  @personas
  Scenario: Changing the budget period
    Given I am Roger
    Then I can change the budget period of my request

  @personas
  Scenario: Changing the procurement group
    Given I am Roger
    Then I can change the procurement group of my request

  @personas
  Scenario: Modify a Request
    Given I am Roger
    Then I can modify my request

  @personas
  Scenario: Count the Total on the line
    Given I am Roger
    When I create a request
    And I enter an amount
    And I enter a price
    Then the amount and the price are multiplied and the result is shown

  @personas
  Scenario: Count the Total of all my requests
    Given I am Roger
    Then I see the total of my requests of the specific procurement groups

  @personas
  Scenario: Priority values
    Given I am Roger
    When I create a request
    Then I can choose the following priority-values
    |High|
    |Normal|
    And the value "Normal" is set by default

  @personas
  Scenario: Prefill field "Replacement / New"
    Given I am Roger
    When I create a request
    Then I can choose the following priority-values
    |Replacement|
    |New|
    And the value "Replacement" is set by default

  @personas
  Scenario: Delete an attachment
    Given I am Roger
    Then I can delete an attachment

  @personas
  Scenario: Download an attachment
    Given I am Roger
    Then I can download an attachment
