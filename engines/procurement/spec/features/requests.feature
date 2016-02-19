Feature: requests (state-behaviour described in seperate feature-file)

#can still change!!
#  @requests @browser
#  Scenario: Create a request
#    Given I am Roger
#    When I create a request
#    Then I choose the budget period
#    And I choose the procurement group
#    And I enter the following information
#    |Article|
#    |Article nr./manufacturer nr.|
#    |Supplier|
#    |Receiver|
#    |Point of Delivery|
#    |Motivation|
#    |Priority|
#    |New/Replacement|
#    |Price|
#    |Quantity Requested|
#    |Attachments|
#    And I see the status "New"

#Final - will not change anymore
  @requests @browser
  Scenario: Delete a Request
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can delete my request

#Final - will not change anymore
  @requests @browser
  Scenario: Modify a Request
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can modify my request
#
##can still change!!
#  @requests @browser
#  Scenario: Editable Fields
#    Given I am Roger
#    When I enter an existing request
#    And the request has not been created by a template article
#    Then I can modify the following information
#    |Article|
#    |Article nr./manufacturer nr.|
#    |Supplier|
#    |Receiver|
#    |Point of Delivery|
#    |Motivation|
#    |Priority|
#    |New/Replacement|
#    |Price|
#    |Quantity Requested|
#    |Attachment|
#
##can still change!!
#  @requests @browser
#  Scenario: Mandatory fields
#    Given I am Roger
#    When I create a request
#    Then the following fields are mandatory
#    |Article|
#    |Motivation|
#    |Quantity Requested|
#    And the mandatory fields are marked in red
#    When I save the request without entering the mandatory information
#    Then the fields with missing information are marked in red
#
##Final - will not change anymore
#  @requests @browser
#  Scenario: Choosing an existing or non existing Model
#    Given I am Roger
#    When I create a request
#    Then I can search a model by typing the model name
#    And according to the search results I can choose the model from a list
#    When no search result is found
#    Then the entered model string is saved
#
##can still change!!
#  @requests @browser
#  Scenario: Choose an article from a Template Category
#    Given I am Roger
#    When I choose an article from a template category
#    Then I see all categories
#    And I see the articles and there prices sorted by category
#    And the following fields are prefilled with the information of the template article
#    |Article|
#    |Article nr./Manufacturer nr|
#    |Supplier|
#    |Quantity|
#    |Price|
#    And the quantity is set to 1

#Final - will not change anymore
  @requests @browser
  Scenario: Changing the budget period
    Given I am Roger
    Given the current date has not yet reached the inspection start date
    Then I can change the budget period of my request

##Final - will not change anymore
  @requests @browser
  Scenario: Changing the procurement group
    Given I am Roger
    Then I can change the procurement group of my request

#Final - will not change anymore
  @requests @browser
  Scenario: Count the Total on the line
    Given I am Roger
    When I create a request
    And I enter the requested amount
    Then the amount and the price are multiplied and the result is shown

##Final - will not change anymore
#  @requests @browser
#  Scenario: Count the Total of all my requests
#    Given I am Roger
#    Then I see the total of my requests of a procurement group

#Final - will not change anymore
  @requests @browser
  Scenario: Priority values
    Given I am Roger
    When I create a request
    Then the priority value "Normal" is set by default
    And I can choose the following priority values
      | High   |
      | Normal |

#Final - will not change anymore
  @requests @browser
  Scenario: Prefill field "Replacement / New"
    Given I am Roger
    When I create a request
#!!# this behaviour has been changed through the google doc
    Then the replacement value "Replacement" is set by default
    And I can choose the following replacement values
      | Replacement |
      | New         |

#  @requests @browser
#  Scenario: Delete an attachment
#    Given I am Roger
#    Then I can delete an attachment
#
##Final - will not change anymore
#  @requests @browser
#  Scenario: Download an attachment
#    Given I am Roger
#    Then I can download an attachment
#
##Final - will not change anymore
#  @requests @browser
#  Scenario: Send an Email
#    Given I am Roger
#    When I Enter the requests of a procurement group
#    Then I see the inspectors of this group
#    And I can send a mail to the group
#
##Final - will not change anymore
#  @requests @browser
#  Scenario: Additional Fields shown to Roger after budget period has ended
#    Given I am Roger
#    Given a request exists
#    When the budget period has ended
#    Then additionally the following information is visible
#    |Approved Quantity|
#    |Inspection Comment|
