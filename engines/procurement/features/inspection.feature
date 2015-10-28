Feature: Inspection (state-behaviour described in seperate feature-file)

# not yet implemented: some fields missing
@personas
Scenario: Create a Request
  Given I am Barbara
  Then I can create a request and give the following information
  |Procurement Group|
  |item description|
  |Requested Quantity|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Priority of Inspection|
  |Supplier|
  |Motivation|
  |Inspection Comment|
  |Receiver|
  |Organisation Unit of Receiver|
  |Attachment|

# not yet implemented: some fields missing
@personas
Scenario: Mandatory Fields
  Given I am Roger
  When I create a request
  Then the following fields are mandatory
  |Procurement Group|
  |item description|
  |Approved quantity|
  |Price|
  |Priority of Inspection|
  |Motivation|
  |Receiver|
  |Organisation Unit of Receiver|

@personas
Scenario: Choosing an existing or non existing Model
  Given I am Barbara
  When I create a request
  Then I can choose a model by typing the model name
  When the model name does not exist
  Then the entered model name is saved

# not yet implemented (the information regarding the state is in a seperate feature file)
@personas
Scenario: delete a request
  Given I am Barbara
  Then I can delete only my own requests

# not yet implemented: some fields missing (the information regarding the state is in a seperate feature file)
@personas
Scenario: modify a request
  Given I am Barbara
  Given a request created by Roger exists
  Then I can modify the following fields of requests of my procurement groups
  |Procurement Group|
  |Approved quantity|
  |Order Size|
  |Price|
  |Priority of Inspection|
  |Supplier|
  |Inspection Comment|
  |Receiver|
  |Organisation Unit of Receiver|

# not yet implemented
@personas
Scenario: Fill Order Size with Approved Quantity
  Given I am Barbara
  When I fill in the approved quantity
  Then the order size is automatically filled with the value of the approved quantity

# not yet implemented: But wait for Nadja to verify this with stakeholders
@personas
Scenario: Give Reason when Partially Excepting or Denying
  Given I am Barbara
  Given a request created by Roger exists
  When I set the approved quantity to 0
  Then I need to give a reason
  When I set the approved quantity smaller than the requested quantity
  Then I need to give a reason
