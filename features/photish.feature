Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  Scenario: Generates the site and runs it on a HTTP server
    When I run `photish init`
    Then the output should contain "Photish site initiated successfully"
    And the exit status should be 0
    And the config file should be created
    And a photos directory should be created
    And a site directory should be created

    When I run `photish generate`
    Then the output should contain "Site generation completed successfully"
    And the exit status should be 0

    When I run `photish host` interactively
    Then the site should be available via HTTP
    And all 25 pages and images should be available
    And not contain any dead links
