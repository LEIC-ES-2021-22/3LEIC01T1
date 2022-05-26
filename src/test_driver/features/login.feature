Feature: Login
  I should be able to sign in to my account, provided I enter correct credentials

#  Background:
#    Given I have users:
#      | email         | password  |
#      | test@test.com | test123   |
#    Given I am in the "Login" page
#    And the field "email" is empty
#    And the field "password" is empty
  Scenario: Successful login
    Given I expect "email" to be ""
    And I expect "password" to be ""
    When I type "test@test.com" in "email"
    And I type "test123" in "password"
    And I tap the "login" button
    Then I expect the text "ALL EVENTS" to be present
