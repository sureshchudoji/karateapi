package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class PerfTest extends Simulation {

  val protocol = karateProtocol(
    //The articleID was displaying in each line in the reports. 
    //To avoid the duplicacy in reports we have added the variable & assigned to Null
    "/api/articles/{articleId}" -> Nil
  )

  //protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
  //protocol.runner.karateEnv("perf")

  // Read the rows from CSV file in circular option
  val csvFeeder = csv("articles.csv").circular
  val createArticle = scenario("Create and delete article").feed(csvFeeder).exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))

  setUp(
    createArticle.inject(
        atOnceUsers(1),
        nothingFor(4 seconds),
        constantUsersPerSec(1) during (10 seconds),
        constantUsersPerSec(2) during (10 seconds),
        rampUsersPerSec(2) to 10 during (20 seconds),
        nothingFor(5 seconds),
        constantUsersPerSec(1) during (5 seconds)
        ).protocols(protocol)
  )

}