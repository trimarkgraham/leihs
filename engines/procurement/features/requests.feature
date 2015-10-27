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
  Scenario: Create a request
    Given I am Roger
    When I create a request
    And I pick a receiver
    Then the organisation unit of the receiver is assigned
