// Four fours is a mathematical puzzle. The goal is to find a mathematical
// expression for every whole number from 1 to 100, using only common
// mathematical symbols and the number four four times.
//
// See https://en.wikipedia.org/wiki/Four_fours
// Playground: https://andrewzc.net/fourfours/
//
// In this case, we will start with the initial values 4, .4, √4 and 4!
// and combine them using the operations addition, subtraction,
// multiplication and division.

val fours = mutableMapOf<Int, MutableSet<Double>>()

fun computeFours() {
  fours.put(1, mutableSetOf<Double>(4.0, 2.0, 24.0, 0.4))
  fours.put(2, mutableSetOf<Double>())
  fours.put(3, mutableSetOf<Double>())
  fours.put(4, mutableSetOf<Double>())
  
  combineSets(1, 1)
  combineSets(1, 2)
  combineSets(1, 3)
  combineSets(2, 2)
}

fun combineSets(countA: Int, countB: Int) {
  fours.get(countA + countB)?.let { dest ->
    fours.get(countA)!!.forEach { a -> 
      fours.get(countB)!!.forEach { b -> 
        dest.add(a + b)
        dest.add(a - b)
        dest.add(b - a)
        dest.add(a * b)
        if (b != 0.0) {
          dest.add((a / b).round(6))
        }
        if (a != 0.0) {
          dest.add((b / a).round(6))
        }
      }
    }
  }
}

fun Double.round(decimals: Int = 2): Double = "%.${decimals}f".format(this).toDouble()

fun printFours() {
  for (i in 1..3) {
    val values = fours.get(i)!!.toTypedArray()
    values.sort()
    val joined = values.joinToString()
    println("$i fours: [$joined]\n")
  }
  val fourSet = fours.get(4)!!
  val found = mutableListOf<Int>()
  val missing = mutableListOf<Int>()
  for (i in 1..100) {
    if (fourSet.contains(i.toDouble())) {
      found.add(i)
    } else {
      missing.add(i)
    }
  }
  val foundString = found.joinToString()
  val missingString = missing.joinToString()
  println("4 fours: [$foundString]\n")
  println("missing: [$missingString]\n")
  if (missingString == "73, 77, 81, 87, 93, 99") {
    println("Success!") 
  }
}

fun main(args: Array<String>) {
  computeFours()
  printFours()
}

