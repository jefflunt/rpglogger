Feature: Markdown parsing and sanitization

Background:
  Given I am signed in with "facebook"
  And a LogBook exists called "Test LogBook" for game "Skyrim" and owned by "fooman"
  And a Section exists called "Test Section" in "Test LogBook"
  And a WorldObject exists called "Test WorldObject" in "Test Section"

Scenario: Markdown is parsed as expected in text fields when displayed
  When I edit the WorldObject "Test WorldObject" in "Test Section"
  And I fill in "world_object[name]" with "Text with `some code` in it"
  And I press "Save"
  Then I should see a "code" tag around the text "some code"
    
Scenario: Markdown is parsed as expected in string fields when displayed
  Given pending

Scenario: Markdown is ignored in integer fields
  Given pending

Scenario: Markdown is sanitized of all script tags
  Given pending

Scenario: Markdown sanitized against SQL injection
  Given pending

Scenario: Markdown is otherwise sanitized as expected
  Given pending