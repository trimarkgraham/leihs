Feature: Exporting the data to a CSV-File

# not yet implemented
Scenario: Export the same fields for all roles
  When I access the procurement overview
  Then I can export the shown information
  And the following fields are exported
  |Budget Period|
  |Procurement Group|
  |item name|
  |Requested Quantity|
  |Approved Quantity|
  |Order Size|
  |Price|
  |Total|
  |Priority of Requester|
  |Priority of Inspector|
  |Supplier|
  |Motivation|
  |Inspection Comment|
  |Receiver|
  |Department|
  |Organisation Unit of Receiver|
  |State|
