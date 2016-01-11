Feature: Inspection (state-behaviour described in seperate feature-file)

@personas
Scenario: Create a Request
  Given I am Barbara
  Then I can create a request and give the following information
  |Budget Period|
  |Procurement Group|
  |Article|
  |Article nr./Manufacturer nr.|
  |Replacement/New|
  |Requested Quantity|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Priority of Inspection|
  |Replacement / New|
  |Supplier|
  |Motivation|
  |Inspection Comment|
  |Receiver|
  |Point of Delivery|
  |Attachment|

@personas
Scenario: Mandatory Fields
  Given I am Barbara
  When I create a request
  Then the following fields are mandatory
  |Budget Period|
  |Procurement Group|
  |Article|
  |Replacement/New|
  |Requested Quantity|
  |Price|
  |Priority of Inspection|
  |Replacement / New|
  |Motivation|
  |Receiver|
  |Point of Delivery|
  And I see which fields are mandatory

@personas
Scenario: Choosing an existing or non existing Model
  Given I am Barbara
  When I create a request
  Then I can choose a model by typing the model name
  When the model name does not exist
  Then the entered model name is saved

@personas
Scenario: delete a request
  Given I am Barbara
  Then I can delete only my own requests

@personas
Scenario: modify a request
  Given I am Barbara
  Given a request created by Roger exists
  Then I can modify the following fields of requests of my procurement groups
  |Article|
  |Article nr./Manufacturer nr.|
  |Replacement/New|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Replacement / New|
  |Supplier|
  |Inspection Comment|
  |Receiver|
  |Point of Delivery|

@personas
Scenario: Fill Order Size with Approved Quantity
  Given I am Barbara
  When I fill in the approved quantity
  Then the order size is automatically filled with the value of the approved quantity
  And the total is calculated according to the multiplication of price and order size

@personas
Scenario: Give Reason when Partially Excepting or Denying
  Given I am Barbara
  Given a request created by Roger exists
  When I set the approved quantity to 0
  Then I need to give a reason
  When I set the approved quantity smaller than the requested quantity
  Then I need to give a reason

@personas
Scenario: View the Limit of Expenses
  Given I am Barbara
  When I view the requests of my group
  I see the limit of expenses
