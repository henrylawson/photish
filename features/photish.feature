Feature: Photish
  In order to generate a basic image gallery
  As a CLI
  I want to run a single command to create a static site

  Scenario: Outputs the provided directories using full arg names
    When I run `photish generate --site-dir /var/tmp/site --photo-dir /var/tmp/photo --output-dir /var/tmp/output`
    Then the output should contain "/var/tmp/site"
    And the output should contain "/var/tmp/photo"
    And the output should contain "/var/tmp/output"

  Scenario: Outputs the provided directories using short arg names
    When I run `photish generate -sd /var/tmp/site -pd /var/tmp/photo -od /var/tmp/output`
    Then the output should contain "/var/tmp/site"
    And the output should contain "/var/tmp/photo"
    And the output should contain "/var/tmp/output"
