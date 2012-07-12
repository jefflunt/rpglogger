Feature: Public sharing with an anonymous user

Background:
  Given a LogBook exists called "Public LogBook" for game "Skyrim" and owned by "facebook_user"
  Given the LogBook "Public LogBook" is marked as public

  Given a LogBook exists called "Private LogBook" for game "Skyrim" and owned by "facebook_user"
  Given the LogBook "Private LogBook" is marked as private

Scenario: Anonymous users can see public, but not private, LogBooks
  When I go to the LogBooks index page
  Then I should see the text "Public LogBook"
  And I should not see the text "Private LogBook"