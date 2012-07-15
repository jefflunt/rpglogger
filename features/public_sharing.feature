Feature: Public sharing with an anonymous user

Background:
  Given I am signed in with provider "facebook"
  
  Given a LogBook exists called "Public LogBook" for game "Skyrim" and owned by "facebook_user"
  Given the LogBook "Public LogBook" is marked as public

  Given a LogBook exists called "Private LogBook" for game "Skyrim" and owned by "facebook_user"
  Given the LogBook "Private LogBook" is marked as private
  
  Given I sign out

Scenario: Anonymous users can see public, but not private, LogBooks
  When I go to the LogBooks index page
  Then I should see the text "Public LogBook"
  And I should not see the text "Private LogBook"
  
Scenario: The owner of a LogBook can add and remove public access to their own LogBook
  When I am signed in with provider "facebook"
  And I go to the edit LogBook page for "Private LogBook"
  And I follow "Make public"
  Then "Private LogBook" should be marked as public
  
  When I follow "Make private"
  Then "Private LogBook" should be marked as private
  