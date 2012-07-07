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

Scenario: Markdown is sanitized of all script tags
  When I edit the WorldObject "Test WorldObject" in "Test Section"
  And I fill in "world_object[name]" with "<script>alert('Hey!')</script> - text outside script"
  And I press "Save"
  Then I should see a "p" tag around the text " - text outside script"