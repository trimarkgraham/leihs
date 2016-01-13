Feature: Inspection (state-behaviour described in seperate feature-file)

@personas
Scenario: Inspection Overview
  Given I am Barbara
  When I enter the inspection
  Then I see the budget periods according to the filters set
  And the budget period shows the total price of the requests of all procurement groups
  And the current budget period is expanded
  And I see the procurement groups according to the filters set
  And the procurement group shows the budget limit of the budget period
  And I see the articles according to the filters set
  And I see requester name of an article
  And I see the organisation of the requester of an article
  And I see the price of an article
  And I see the requested amount of an article
  And I see the approved amount of an article
  And I see the ordered amount of an article
  And I see the total price of a request
  And I see the priority of a request
  And I see the state of a request
  And I can edit the requests

@personas
Scenario: Filtering Inspection Overview
  Given I am Barbara
  When I enter the inspection
  Then I can filter the following information
  |Budget Periods|
  |Procurement Groups|
  |Organisations|
  |Priority|
  |State|

@personas
Scenario: Sorting Inspection Overview
  Given I am Barbara
  When I enter the inspection
  Then I can sort the following information
  |Article|
  |Requester|
  |Organisation|
  |Price|
  |Quantity|
  |Total Price|
  |Priority|
  |State|

@personas
Scenario: Create a Request
  Given I am Barbara
  Then I can create a request and give the following information
  |Budget Period|
  |Procurement Group|
  |Article|
  |Article nr./Manufacturer nr.|
  |Requested Quantity|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Priority|
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
  |Requested Quantity|
  |Motivation|
  And I see which fields are mandatory
  When I save the request with missing information
  Then an error msg. is shown

@personas
Scenario: delete a request
  Given I am Barbara
  Then I can delete only my own requests

@personas
Scenario: modify a request
  Given I am Barbara
  Given a request created by Roger exists
  Then I can modify the following information of requests of my own procurement groups
  |Article|
  |Article nr./Manufacturer nr.|
  |Replacement/New|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Supplier|
  |Inspection Comment|
  |Receiver|
  |Point of Delivery|
  |Attachment|

@personas
Scenario: Fill Order Size with Approved Quantity
  Given I am Barbara
  When I enter the approved quantity
  Then the order size is automatically filled with the value of the approved quantity
  And the total is calculated according to the multiplication of price and order size

@personas
Scenario: Size of the amount fields
  The order amount can be smaller and greater than the approved amount and the requested amount
  The approved amount can be smaller and greater than the requested amount and the ordered amount

@personas
Scenario: Give Reason when Partially Excepting or Denying
  Given I am Barbara
  Given a request created by Roger exists
  When I set the approved quantity to 0
  Then I need to give an inspection comment
  When I set the approved quantity smaller than the requested quantity
  Then I need to give an inspection comment
  When I save without entering the inspection comment
  Then I receive an error msg.

@personas
Scenario: Delete information when moving a request to another group
  Given I am Barbara
  When I move a request to another group where I am not the responsible
  Then the accepted amount is deleted
  And the ordered amount is deleted
  And the inspection comment is deleted
  And I receive the message that the order has been moved
