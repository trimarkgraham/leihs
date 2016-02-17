Feature: section "Managing Requests"

Scenario: What to see in section "Requests" as Roger
    Given I am Roger
    And no requests exist
    When I navigate to the requests page
    Then I see the headers of the colums of the overview
    And I see the amount of requests which are listed is 0
    And I see the current budget period
    And I see the requested amount per budget period
    And I see the requested amount per group of each budget period
    And I do not see the budget limits
    And I do not see the percentage signs
    And I see when the requesting phase of this budget period ends
    And I see when the inspection phase of this budget period ends
    And I see all procurement groups
    And the current budget period is selected
    And all groups are selected
    And all organisations are selected
    And both priorities are selected
    And all states are selected
    And the search field is empty
    
Scenario: Using the filters as Roger
    Given I am Roger
    When I navigate to the requests page
    Then I do not see the filter "only show my own requests"
    When I select one or more budget periods
    And I select one or more groups
    And I select a specific organisation
    And I select one ore both priorities
    And I select one or more states
    And I enter a search string
    Then the list of requests is adjusted immediately according to the filters chosen
    And the amount of requests found is shown
    
Scenario: What to see in section "Requests" as Barbara
    Given I am Barbara
    And no requests exist
    When I navigate to the requests page
    Then I see the headers of the colums of the overview
    And I see the amount of requests which are listed is 0
    And I see the current budget period
    And I see the requested amount per budget period
    And I see the requested amount per group of each budget period
    And I see the budget limits of all groups
    And I see the total of all ordered amounts of each groups
    And I see the total of all ordered amounts of a budget period
    And I see the percentage of budget used compared to the budget limit of my group
    And I see when the requesting phase of this budget period ends
    And I see when the inspection phase of this budget period ends
    And I see all procurement groups
    And not only my requests are shown
    And the current budget period is selected
    And all groups are selected
    And all organisations are selected
    And both priorities are selected
    And all states are selected
    And the search field is empty
    
Scenario: Using the filters as Barbara
    Given I am Barbara
    And three requests exist from the current budget period
    And two requests have been created by myself
    And one request has been created by Roger
    When I navigate to the requests page
    And I select "only show my own requests"
    And I select the current budget period
    And I select all groups
    And I select all organisations
    And I select both priorities
    And I select all states
    And I enter leave the search string empty
    Then the list of requests is adjusted immediately
    And I see both my requests
    And the amount of requests found is shown as 2
    
Scenario: Creating a request for a group
    Given I am <username>
    When I navigate the requests page
    And I press on the plus icon of a group
    Then I am navigated to the new request page
    When I enter an article
    And I enter a reason
    And I choose the option "replacement/new"
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username  |
      | Barbara   |
      | Roger     |
  
Scenario: Creating a request through a budget period selecting a template article
    Given I am <username>
    When I navigate to the requests page
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
      | username  |
      | Barbara   |
      | Roger     |
    
Scenario: Creating a request through a budget period selecting a group
    Given I am <username>
    When I navigate to the requests page
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
      | username  |
      | Barbara   |
      | Roger     |
    
Scenario: Creating a freetext request inside the new request page 
    Given I am <username>
    When I am navigated to the new requests page
    And I press on the plus icon
    Then a new request line is added
    When I fill in all mandatory information
    And I click on save
    Then I see a success message
    And the request with all given information was created successfully in the database
    Examples:
      | username  |
      | Barbara   |
      | Roger     |
    
Scenario: Creating a request from a group template inside the new request page
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
      | username  |
      | Barbara   |
      | Roger     |

Scenario: Mandatory fields
    Given I am <username>
    When I navigate the requests page
    And I press on the plus icon of a group
    Then I am navigated to the new request page
    When I type the first character in a field of the request form
    And the field "article" is marked red
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
      | username  |
      | Barbara   |
      | Roger     |
      
Scenario: sorting requests
    Given I am <username>
    When I navigate the requests page
    And I can sort the requests by article name
    And I can sort the requests by requester
    And I can sort the requests by organisation
    And I can sort the requests by price
    And I can sort the requests by quantity
    And I can sort the requests by the total amount
    And I can sort the requests by priority
    And I can sort the requests by state
