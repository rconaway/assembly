package turtles.assembly

object Common {


  def out(text: String): Unit = print(text)

  def textToInt(text: String): Int =
    try {
      text.toInt
    } catch {
      case _: Exception => null.asInstanceOf[Int]
    }

  def intToText(n:Int):String = n.toString

}
