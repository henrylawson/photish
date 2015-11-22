Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  Scenario: Generates the site and runs it on a HTTP server
    Given a config file
    And a photo directory
    And a site directory

    When I run `photish generate`
    Then the output should contain "Site generation completed successfully"
    And the exit status should be 0

    When I run `photish host` interactively
    Then the site should be available via HTTP
    And all 47 pages and images should be available
    And not contain any dead links
    And binding pry
