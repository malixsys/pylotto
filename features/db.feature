# encoding: utf-8
Feature: Tickets
  In order to persist state
  As a program
  I want to save state 

  Scenario Outline: Read / Write
    When I save "<input>"
    Then load should return "<output>"
    
    Examples:
    | input   | output  |
    | Martin  | Martin  |
    | Alix    |  Alix   |