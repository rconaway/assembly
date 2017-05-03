package turtles.assembly

import Common._

object Fibonacci {

  def fibonacci(n:Int):Int = {
    if (n < 2) {
      n
    } else {
      fibonacci(n-1) + fibonacci(n-2)
    }
  }

  def parseCommandLine(args:Array[String]):Integer =
    if (args.length < 1) {
      null
    } else {
      textToInt(args(0))
    }
}
