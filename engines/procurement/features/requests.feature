Feature: requests (state-behaviour described in seperate feature-file)

  # not yet implemented: some fields missing
  @personas
  Scenario: Create a request
    Given I am Roger
    When I create a request
    Then I can see the following fields
    |Procurement Group|
    |item description|
    |Quantity|
    |Approved Quantity|
    |Order Size|
    |Price|
    |Total|
    |Priority|
    |Priority of Inspection|
    |Supplier|
    |Motivation|
    |Inspection Comment|
    |Receiver|
    |Organisation Unit of Receiver|
    |Attachment|

  # not yet implemented: some fields missing
  @personas
  Scenario: Editable Fields
    Given I am Roger
    When I create a Request
    Then I can modify the following fields
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

  # not yet implemented
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
    And I see which fields are mandatory

  @personas
  Scenario: Choosing an existing or non existing Model
    Given I am Roger
    When I create a request
    Then I can choose a model by typing the model name
    When the model name does not exist
    Then the entered model name is saved

  # not yet implemented: some fields missing
  @personas
  Scenario: Show values set by inspector
    Given I am Barbara
    Given a request has been created by @Roger
    When I modify the folling fields
    |Approved Quantity|
    |Order Size|
    |Price|
    |Priority of Inspection|
    |Supplier|
    |Inspection Comment|
    |Receiver|
    |Organisation Unit of Receiver|
    |Attachment|
    Then @Roger sees the entered values

  # not yet implemented
  @personas
  Scenario: Delete whole Request
    Given I am Roger
    Given a request exists
    When the inspection date for the current budget period has not yet been reached
    Then I can delete only my own requests

  # not yet implemented
  @personas
  Scenario: Delete a Request Line
    Given I am Roger
    Given a request exists
    When the inspection date for the current budget period has not yet been reached
    Then I can delete a request line of an existing request

  # not yet implemented
  @personas
  Scenario: Delete a Request Line when Creating a Request
    Given I am Roger
    When I create a new request
    Then I can delete an already added request line

  @personas
  Scenario: Modify a Request
    Given I am Roger
    When the inspection date for the current budget period has not yet been reached
    Then I can modify only my own requests

  # not yet implemented: waiting for Nadja to find out more about API
  @personas
  Scenario: Pick Receiver and Organisation
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

  # not yet implemented
  @personas
  Scenario: Priority values
    Given I am Roger
    When I create a request
    Then I can choose the following priority-values
    |High|
    |Medium|
    And the value "Medium" is set by default
