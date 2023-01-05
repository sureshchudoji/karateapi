
Feature: Test for the home page

Background: 
    * configure ssl = true
    Given url apiURL

Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains 'welcome'
    And match response.tags contains ['implementations','welcome', 'introduction', 'codebaseShow','ipsum','qui','et','quia','cupiditate','deserunt']
    And match response.tags !contains 'animals'
    And match response.tags contains any ['qui','ipsum']
    And match response.tags != "#string"
    And match response.tags == "#array"
    And match each response.tags == "#string"

Scenario: Get 10 articles from the page
    #Validate DateTime using timeValidator()
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles == '#[10]'
    And match response.articlesCount != 197

    #To verify each object of the response body
    #And match response == {"articles": '#array', "articlesCount": 200}
    And match response.articles[0].createdAt contains '2022-12'

    #Loop in the array & verify if atleast one item contains the value 13
    And match response.articles[*].favoritesCount contains 0
    And match response.articles[*].author.bio contains null
    
    #To shortcut the path just use 2 dots to search for an item
    And match response..bio contains null

    #To verify that the value of 'following' is false for all the arrays
    And match each response..following == false

    #Validate the data type of each response
    And match each response..following == '#boolean'
    And match each response..favoritesCount == '#number'
    
    #Validates if the bio value is a string or null (##string verifies if it's a string or null value)
    And match each response..bio == '##string'

    #Schema Validation
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            }
        }
    """

Scenario: SCHEMA VALIDATION - CODE REFACTORED
    * def timeValidator = read('classpath:helpers/timeValidator.js')
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    #And match response == {"articles": '#[10]', "articlesCount": 201}
    And match each response.articles ==
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            }
        }
    """