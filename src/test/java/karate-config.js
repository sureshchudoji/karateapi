function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
    apiURL: 'https://conduit.productionready.io/api/'
  }
  
  if (env == 'dev') {
    config.userEmail = 'schudoji@test.com'
    config.userPassword = 'Password123'
  } 
  if (env == 'qa') {
    config.userEmail = 'shaniqua549@test.com'
    config.userPassword = 'Password123'
  }

  //Call the feature file 'CreateToken' to get teh auth token & config it in the header
  var accessToken = karate.call('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}