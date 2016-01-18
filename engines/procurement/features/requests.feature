Feature: requests (state-behaviour described in seperate feature-file)

  @personas
  Scenario: Create a request
    Given I am Roger
    When I create a request
    Then I choose the budget period
    And I choose the procurement group
    And I enter the following information
    |Article|
    |Article nr./manufacturer nr.|
    |Supplier|
    |Receiver|
    |Point of Delivery|
    |Motivation|
    |Priority|
    |New/Replacement|
    |Price|
    |Quantity Requested|
    |Attachments|
    And I see the status "New"

  @personas
  Scenario: Delete a Request
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can delete my request

  @personas
  Scenario: Modify a Request
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can modify my request

  @personas
  Scenario: Editable Fields
    Given I am Roger
    When I enter an existing request
    And the request has not been created by a template article
    Then I can modify the following information
    |Article|
    |Article nr./manufacturer nr.|
    |Supplier|
    |Receiver|
    |Point of Delivery|
    |Motivation|
    |Priority|
    |New/Replacement|
    |Price|
    |Quantity Requested|
    |Attachment|

  @personas
  Scenario: Mandatory fields
    Given I am Roger
    When I create a request
    Then the following fields are mandatory
    |Article|
    |Motivation|
    |Quantity Requested|
    And the mandatory fields are marked
    When I save the request without entering the mandatory information
    Then I receive an error message

  @personas
  Scenario: Mandatory fields not filled
    Given I am Roger
    Given

  @personas
  Scenario: Choosing an existing or non existing Model
    Given I am Roger
    When I create a request
    Then I can search a model by typing the model name
    And according to the search results I can choose the model from a list
    When no search result is found
    Then the entered model string is saved

  @personas
  Scenario: Choose an article from a Template Category
    Given I am Roger
    When I choose an article from a template category
    Then I see all categories
    And I see the articles and there prices sorted by category
    And the following fields are prefilled with the information of the template article
    |Article|
    |Article nr./Manufacturer nr|
    |Supplier|
    |Quantity|
    |Price|
    And the quantity is set to 1

  @personas
  Scenario: Changing the budget period
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can change the budget period of my request

  @personas
  Scenario: Changing the procurement group
    Given I am Roger
    Then I can change the procurement group of my request

  @personas
  Scenario: Count the Total on the line
    Given I am Roger
    When I create a request
    And I enter the requested amount
    Then the amount and the price are multiplied and the result is shown

  @personas
  Scenario: Count the Total of all my requests
    Given I am Roger
    Then I see the total of my requests of a procurement group

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

  @personas
  Scenario: Send an Email
    Given I am Roger
    When I Enter the requests of a procurement group
    Then I see the inspectors of this group
    And I can send a mail to the group

  @personas
  Scenario: Additional Fields shown to Roger after budget period has ended
    Given I am Roger
    Given a request exists
    When the budget period has ended
    Then additionally the following information is visible
    |Approved Quantity|
    |Inspection Comment|
