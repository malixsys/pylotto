# encoding: utf-8
Feature: Tickets
  In order to draw the lotto
  As a participant
  I want to purchase a ticket

  Scenario: Program status
    Given we have the following tickets:
      | number | name     |
      | 1      | François |
    When I enter "status"
    And I run the program
    Then the output should be "Ticket 1 - François"
    
  Scenario Outline: Buying the first ticket
    Given we have the following tickets:
      | number | name |
    When I enter "<input>"
    And I run the program
    Then the output should be "<output>"
    
    Examples:
    | input           | output               |
    | achat François  | Ticket 1 - François  |
    | achat Jean      | Ticket 1 - Jean      |
    | status          | Aucun ticket         | 
