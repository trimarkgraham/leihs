Feature: requests (state-behaviour described in seperate feature-file)

  @personas
  Scenario: Create a request
    Given I am Roger
    When I create a request
    Then I set the following information
    |Procurement Group|
    |Article|
    |Article nr./manufacturer nr.|
    |New/Replacement|
    |Quantity|
    |Price|
    |Priority|
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
    |Procurement Group|
    |Article|
    |Article nr./manufacturer nr.|
    |New/Replacement|
    |Quantity|
    |Price|
    |Priority|
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
    |Procurement Group|
    |Article|
    |New/Replacement|
    |Quantity|
    |Priority|
    |Motivation|
    |Receiver|
    |Point of Delivery|
    And I see which fields are mandatory

  @personas
  Scenario: Choose from a Category
    Given I am Roger
    When I choose an article from a category
    Then the if given the following fields are prefilled
    |Article|
    |Quantity|
    |Price|
    |Supplier|
    And the quantity is set to 1

  @personas
  Scenario: Choosing an existing or non existing Model
    Given I am Roger
    When I create a request
    Then I can choose a model by typing the model name
    When the model name does not exist
    Then the entered model name is saved

  @personas
  Scenario: Delete whole Request
    Given I am Roger
    Given a request exists
    When the inspection date for the current budget period has not yet been reached
    Then I can delete only my own requests

  @personas
  Scenario: Delete a Request Line
    Given I am Roger
    Given a request exists
    When the inspection date for the current budget period has not yet been reached
    Then I can delete a request line of an existing request

  @personas
  Scenario: Delete a Request Line when Creating a Request
    Given I am Roger
    When I create a new request
    Then I can delete an already added request line

  @personas
  Scenario: Modify a Request
    Given I am Roger
    Then I can modify only my own requests

  @personas
  Scenario: Count the Total on the line
    Given I am Roger
    When I create a request
    And I enter an amount
    And I enter a price
    Then the amount and the price are multiplied and the result is shown

  @personas
  Scenario: Priority values
    Given I am Roger
    When I create a request
    Then I can choose the following priority-values
    |High|
    |Normal|
    And the value "Normal" is set by default
