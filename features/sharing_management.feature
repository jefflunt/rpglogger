Feature: Sharing management by the owner of a LogBook

Background:
  Given a user named "google_user" with provider "google_oauth2" and uid "1234" exists
  Given a user named "facebook_user" with provider "facebook" and uid "1234" exists
  
  Given a LogBook exists called "Shared LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Shared Section" in "Shared LogBook"
  Given a WorldObject exists called "Shared WorldObject" in "Shared Section"
  Given the LogBook "Shared LogBook" is marked as private
  
  Given a LogBook exists called "Public LogBook" for game "Skyrim" and owned by "facebook_user"
  Given a Section exists called "Public Section" in "Public LogBook"
  Given a WorldObject exists called "Public WorldObject" in "Public Section"
  Given the LogBook "Public LogBook" is marked as public
  
Scenario: LogBook owners can add and remove private read-only access
  Given pending
  
Scenario: LogBook owners can add and remove private read-write access
  Given pending
  
Scenario: LogBook owners can add and remove public read-only access
  Given pending
