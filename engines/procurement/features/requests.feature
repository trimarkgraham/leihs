Feature: requests

  @personas
  Scenario: Create a request
    Given I am Roger
    Then I can create a request and give the following information
    |Procurement Group|
    |item description|
    |Quantity|
    |Price|
    |Priority|
    |Supplier|
    |Motivation|
    |Receiver|
    |Organisation Unit of Receiver|
    |Attachment|

  @personas
  Scenario: Mandatory fields
    Given I am Roger
    When I create a request
    Then the following fields are mandatory
    |Procurement Group|
    |item description|
    |Quantity|
    |Priority|
    |Motivation|
    |Receiver|
    |Organisation Unit of Receiver|

  @personas
  Scenario: delete a request
    Given I am Roger
    When the inspection date for the current budget period has not yet been reached
    Then I can delete only my own requests

  @personas
  Scenario: edit a request
    Given I am Roger
    When the inspection date for the current budget period has not yet been reached
    Then I can edit only my own requests

  @personas
  Scenario: Create a request
    Given I am Roger
    When I create a request
    And I pick a receiver
    Then the organisation unit of the receiver is assigned

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
    |Medium|

  @personas
  Scenario: Change procurement group
    Given I am Roger
    When I create a request
    And I add item lines
    Then I can change the selected procurement group of these item lines

  @personas
  Scenario: choosing an existing or non existing model
    Given I am Roger
    When I create a request
    Then I can choose a model by typing the model name
    When the model name does not exist
    Then the entered model name is saved
