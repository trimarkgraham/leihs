Feature: Exporting the data to a CSV-File

# not yet implemented
Scenario: Export data
  When I access the procurement overview
  Then I can export the shown information
  And the following fields are exported
  |Budget Period|
  |Procurement Group|
  |article|
  |article nr./manufacturer nr|
  |Replacement|
  |New|
  |Requested Quantity|
  |Approved Quantity|
  |Order Quantity|
  |Price|
  |Total|
  |Priority|
  |Motivation|
  |Supplier|
  |Inspection Comment|
  |Receiver|
  |Point of Delivery|
  |Organisation Unit of Receiver|
  |State|
