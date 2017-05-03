package turtles.assembly
import Common._

object Hello extends App {

  val hello = "Hello, "
  val default_name = "whoever you are"
  val bang = "!\n"

  var name:String = _

  if (args.length < 1) {
    name = default_name
  } else {
    name = args(0)
  }

  out(hello)
  out(name)
  out(bang)

  System.exit(0)

}
