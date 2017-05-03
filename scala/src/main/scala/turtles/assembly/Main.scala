package turtles.assembly
import Common._
import Fibonacci._

object Main extends App {

  val usageMessage = "Usage: fibonacci <count>\n"

  val n = parseCommandLine(args)
  if (n == null) {
    usage()
  } else {
    for (i <- 1 until n) {
      val fib = fibonacci(i)
      val fibStr = intToText(fib) + "\n"
      out (fibStr)
    }
  }

  def usage():Unit = print(usageMessage)

}
