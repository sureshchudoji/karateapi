@debug
Feature: Articles

Background: 
    * configure ssl = true
    * url apiURL

    #Read the JSON file from the file & get the JSON object
    * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')

    #Generate random values & assign them to the JSON Object 
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
   

Scenario: Create New Article
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.title == articleRequestBody.article.title
    
@debug
Scenario: Create and Delete Article
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
    And match response.article.title == articleRequestBody.article.title
    * def articleId = response.article.slug
    * print 'Article-ID: '+ articleId

    #Given header Authorization = 'Token ' + token
    Given path 'articles', articleId
    When method Delete
    Then status 204