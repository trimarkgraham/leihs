Feature: section Managing Requests

#!!# we should define a world
  Background:
    Given the current budget period exist

    Scenario: What to see in section "Requests" as requester only
      Given I am Roger
      And one request exists
      When I navigate to the requests overview page
      Then I see the headers of the colums of the overview
      And I see the amount of requests which are listed is 1
      And I see the current budget period
      And I see the requested amount per budget period
      And I see the requested amount per group of each budget period
      And I see when the requesting phase of this budget period ends
      And I see when the inspection phase of this budget period ends
      And I see all procurement groups
      And only my requests are shown
      And I see the following request information
      | article name |
      | name of the requester  |
      | department    |
      | organisation    |
      | price    |
      | requested amount    |
      | total amount    |
      | priority    |
      | state    |
      And the filter current budget period is selected
      And filter all groups are selected
      And filter all organisations are selected
      And filter both priorities are selected
      And filter all states are selected
      And the search field is empty

  @managing_requests @browser
  Scenario: Using the filters as requester only
    Given I am Roger
    When I navigate to the requests overview page
    Then I do not see the filter "only show my own requests"
    When I select one or more budget periods
    And I select one or more groups
    And I select a specific organisation
    And I select one ore both priorities
    And I select one or more states
    And I enter a search string
    Then the list of requests is adjusted immediately according to the filters chosen
    And the amount of requests found is shown

  @managing_requests @browser
  Scenario: Creating a request as requester only
    Given I am Roger
    And a receiver exists
    And a point of delivery exists
    When I am navigated to the new requests page
    And I enter the following information
     |Article|
     |Article nr./manufacturer nr.|
     |Supplier|
     |Motivation|
     |Price|
     |Requested Quantity|
    Then the amount and the price are multiplied and the result is shown
    When I upload a file
    And I choose the name of a receiver
    And I choose the point of delivery
    And I choose the option "High" of the field "Priority"
    And I choose the option "New" of the field "Replacement/New"
    And I see the status "New"
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database

  @managing_requests @browser
  Scenario Outline: Creating a request for a group
    Given I am <username>
    When I navigate to the requests overview page
    And I press on the plus icon of a group
    Then I am navigated to the new request page
    When I enter an article
    And I enter an amount
    And I enter a reason
    And I choose the option "replacement/new"
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: Creating a request through a budget period selecting a template article
    Given I am <username>
    When I navigate to the requests overview page
    And I press on the plus icon of the budget period
    Then I am navigated to the templates overview
    And I see the budget period
    And I see the start date of the requesting phase
    And I see the end date of the inspection phase
    And I see all categories of all groups listed
    When I press on a catory
    Then I see all template articles of this category
    When I choose a template article
    Then I am navigated to the new requests page of the specific group
    When I fill in all mandatory information
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: Creating a request through a budget period selecting a group
    Given I am <username>
    When I navigate to the requests overview page
    And I press on the plus icon of the budget period
    Then I am navigated to the templates overview
    And I see all groups listed
    When I choose a group
    Then I am navigated to the new requests page of the specific group
    When I fill in all mandatory information
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: Creating a freetext request inside the new request page
    Given I am <username>
    When I am navigated to the new requests page
    And I press on the plus icon
    Then a new request line is added
    When I fill in all mandatory information
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: Creating a request from a group template inside the new request page
    Given I am <username>
    And a template article exists
    And the template article contains a articlenr/suppliernr
    And the template article contains a supplier
    And the template article contains a price
    When I am navigated to the new requests page
    And I click on a category
    And I click on a template article
    Then a new request line is added
    And the field article is prefilled with the name of the template article chosen
    And the field articlenr/suppliernr is prefilled with the articlenr/suppliernr of the template article chosen
    And the field supplier is prefilled with the supplier of the template article chosen
    And the field price is prefilled with the price of the template article chosen
    When I enter the motivation
    And I choose the option "new"
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: Request deleted because no information entered
    Given I am <username>
    When I navigate the requests overview page
    And I press on the plus icon of a group
    Then I am navigated to the new request page
    When I type the first character in a field of the request form
    Then the field "article" is marked red
    And the field "requested quantity" is marked red
    And the field "motivation" is marked red
    And the field "new/replacement" is marked red
    And the fields marked red are mandatory
    And the field where I have typed the character is not marked red
    When I delete this character
    Then all fields turn white
    When I click on save
    Then the line is deleted
    And no information is saved to the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @managing_requests @browser
  Scenario Outline: sorting requests
    Given I am <username>
    When I navigate to the requests overview page
    And I sort the requests by
      | article name     |
      | requester        |
      | organisation     |
      | price            |
      | quantity         |
      | the total amount |
      | priority         |
      | state            |
    Then the data is shown in the according sort order
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @requests @browser
  Scenario Outline: Delete a Request
    Given I am <username>
    And a request exists created by myself
    And the current date has not yet reached the inspection start date
    When I navigate to the requests page
#!!# this is needed
    And I select all budget periods
#!!# this is needed
    And I select all groups
#!!# this is needed
    And I open the request
#!!# just referring to the mentioned request
#    And I delete my request
    And I delete the request
    Then I receive a message asking me if I am sure I want to delete the data
#!!# this is not possible, either this
    When I click on "yes"
    Then I the request is successfully deleted in the database
#!!# or this. in alternative we have to write it as outline
    When I click on "no"
    Then I am redirected to the requests page
    And the request is not deleted in the database
    Examples:
      | username |
#??# Barbara is not defined as a requester. should it be?
      | Barbara  |
      | Roger    |

  @requests @browser
  Scenario Outline: Modify a Request
    Given I am <username>
    And a request exists created by myself
    And the current date has not yet reached the inspection start date
    Then I can modify my request
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @requests @browser
  Scenario Outline: Choosing an existing or non existing Model
    Given I am <username>
    When I am navigated to the new request page
    Then I can search a model by typing the article name
    And according to the search result I can choose the article from a list
    When no search result is found
    Then the entered article name is saved
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @requests @browser
  Scenario: Moving request to another budget period as requester only
    Given I am Roger
    And two budget periods exist
    And a request created by myself exists
    And the current date has not yet reached the inspection start date
    When I navigate to the requests page
    And I move the request to the other budget period
    And I see a success message
    And the changes are saved successfully to the database

  @requests @browser
  Scenario: Moving request to another group as requester only
    Given I am Roger
    And two groups exist
    And a request created by myself exists
    And the current date has not yet reached the inspection start date
    When I navigate to the requests page
    And I move the request to the other group
    Then I see a success message
    And the changes are saved successfully to the database

  @requests @browser
  Scenario Outline: Priority values
    Given I am <username>
    When I create a request
    Then the priority value "Normal" is set by default
    And I can choose the following priority values
      | High   |
      | Normal |
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  @requests @browser
  Scenario Outline: Prefill field "Replacement / New"
    Given I am <username>
    When I create a request
    Then the replacement value "Replacement" is set by default
    And I can choose the following replacement values
      | Replacement |
      | New         |
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  Scenario Outline: Delete an attachment
    Given I am <username>
    And a request created by myself exists
    And the request includes an attachment
    When I am navigated to the request page
    And I delete the attachment
    And I click on save
    Then I see a success message
    And the attachment is deleted successfully from the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  #This scenario does not work yet! Save button is not enabled after uploading a file
  Scenario Outline: Download an attachment
    Given I am <username>
    And a request created by myself exists
    And the request includes an attachment
    When I am navigated to the request page
    And I download the attachment
    Then The file is downloaded
    Then I see a success message
    And the attachment is deleted successfully from the database
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  Scenario Outline: View an attachment .jpg
    Given I am <username>
    And a request created by myself exists
    And the request includes an attachment with the attribute .jpg
    When I am navigated to the request page
    And I click on the attachment
    Then The content of the file is shown in a viewer
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  Scenario Outline: View an attachment .pdf
    Given I am <username>
    And a request created by myself exists
    And the request includes an attachment with the attribute .pdf
    When I am navigated to the request page
    And I click on the attachment
    Then The content of the file is shown in a viewer
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  Scenario Outline: Send an email to a group
    Given I am <username>
    And an email for a group exists
    When I am navigated to the request page
    And I click on the email icon
    Then the email program is opened
    And the receiver of the email is the email of the group
    And the subject of the email is "Frage zum Beschaffungsantrag"
    And the group name is placed in () at the end of the subject
    Examples:
      | username |
      | Barbara  |
      | Roger    |

  Scenario: Additional Fields shown to requester only after budget period has ended
    Given I am Roger
    And the budget period has ended
    And a request created by myself exists
    And the inspector has approved the request
    And the inspector has entered an inspection comment
    When I navigate to the requests overview page
    Then I see the requested quantity
    And I see the approved quantity
    When I edit the request
    Then I see the approved quantity
    And I see the inspection comment
