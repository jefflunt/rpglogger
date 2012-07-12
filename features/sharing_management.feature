Feature: Sharing management by the owner of a LogBook

Background:
  Given I am signed in with provider "facebook"
  Given a user named "google_user" with provider "google_oauth2" and uid "1234" exists
  
  Given a LogBook exists called "Shared LogBook" for game "Skyrim" and owned by "facebook_user"
  Given the LogBook "Shared LogBook" is marked as private  
  
  Given I am signed in with provider "facebook"
  
Scenario: LogBook owners can add and remove users editors
  Given the number of editor users on "Shared LogBook" should be 0

  When I go to the edit LogBook page for "Shared LogBook"
  And I fill in "shares_new_google_user" with "google_user"
  And I press "Add users"
  
  Then the number of editor users on "Shared LogBook" should be 1
  
  When I follow "Remove access"
  Then the number of editor users on "Shared LogBook" should be 0
  