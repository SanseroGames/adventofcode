import java.io.File
import java.lang.RuntimeException
import java.util.*

abstract class ArgumentMode(val arg: Long) {
    abstract fun getValue(): Long
    abstract fun setValue(value: Long)
}

class ImmediateMode(arg: Long) : ArgumentMode(arg) {
    override fun getValue(): Long {
        return arg
    }

    override fun setValue(value: Long) {
        throw RuntimeException("Immediate Mode does not support setting value")
    }
}

class PositionMode(arg: Long, private val mem: Memory) : ArgumentMode(arg) {
    override fun getValue(): Long {
        return mem[arg]
    }

    override fun setValue(value: Long) {
        mem[arg] = value
    }
}

class RelativeMode(arg: Long, private val mem: Memory, private val base: Long) : ArgumentMode(arg) {
    override fun getValue(): Long {
        return mem[arg + base]
    }

    override fun setValue(value: Long) {
        mem[arg + base] = value
    }

}

class Memory(program: List<Long>) {

    private val FRAME_SIZE = 128

    private val memMap = mutableMapOf<Long, MutableList<Long>>()

    init {
        for (i in program.indices) {
            this[i.toLong()] = program[i]
        }
    }

    operator fun get(addr: Long): Long {
        var page = memMap[addr / FRAME_SIZE]
        if (page == null) {
            page = MutableList<Long>(FRAME_SIZE) { 0 }
            memMap[addr / FRAME_SIZE] = page
        }
        return page[(addr % FRAME_SIZE).toInt()]
    }

    operator fun set(addr: Long, value: Long) {
        var page = memMap[addr / FRAME_SIZE]
        if (page == null) {
            page = MutableList<Long>(FRAME_SIZE) { 0 }
            memMap[addr / FRAME_SIZE] = page
        }
        page[(addr % FRAME_SIZE).toInt()] = value
    }
}


class Interpreter(private val program: Memory) {
    private var relativeBase = 0L
    private var pc = 0L
    private var isRunning = false

    private fun addOp(src1: ArgumentMode, src2: ArgumentMode, dest: ArgumentMode) {
        dest.setValue(src1.getValue() + src2.getValue())
        pc += 4
    }

    private fun multOp(src1: ArgumentMode, src2: ArgumentMode, dest: ArgumentMode) {
        dest.setValue(src1.getValue() * src2.getValue())
        pc += 4
    }

    @Suppress("UNUSED_PARAMETER")
    private fun inputOp(dest: ArgumentMode, ignored1: ArgumentMode, ignored2: ArgumentMode) {
        print(">")
        val scan = Scanner(System.`in`)
        dest.setValue(scan.nextLong())
        pc += 2
    }

    @Suppress("UNUSED_PARAMETER")
    private fun outputOp(dest: ArgumentMode, ignored1: ArgumentMode, ignored2: ArgumentMode) {
        print(dest.getValue())
        pc += 2
    }

    @Suppress("UNUSED_PARAMETER")
    private fun jnzOp(condition: ArgumentMode, target: ArgumentMode, ignored2: ArgumentMode) {
        if (condition.getValue() != 0L)
            pc = target.getValue()
        else
            pc += 3
    }

    @Suppress("UNUSED_PARAMETER")
    private fun jzOp(condition: ArgumentMode, target: ArgumentMode, ignored2: ArgumentMode) {
        if (condition.getValue() == 0L)
            pc = target.getValue()
        else
            pc += 3
    }

    private fun lessOp(smaller: ArgumentMode, larger: ArgumentMode, dest: ArgumentMode) {
        dest.setValue(if (smaller.getValue() < larger.getValue()) 1L else 0L)
        pc += 4
    }

    private fun equalOp(src1: ArgumentMode, src2: ArgumentMode, dest: ArgumentMode) {
        dest.setValue(if (src1.getValue() == src2.getValue()) 1L else 0L)
        pc += 4
    }

    @Suppress("UNUSED_PARAMETER")
    private fun setBaseOp(arg: ArgumentMode, ignored1: ArgumentMode, ignored2: ArgumentMode) {
        relativeBase += arg.getValue()
        pc += 2
    }

    @Suppress("UNUSED_PARAMETER")
    private fun haltOp(arg: ArgumentMode, ignored1: ArgumentMode, ignored2: ArgumentMode) {
        isRunning = false
        pc += 1
    }

    private fun getMode(mode: Long, value: Long): ArgumentMode {
        return when (mode) {
            0L -> PositionMode(value, program)
            1L -> ImmediateMode(value)
            2L -> RelativeMode(value, program, relativeBase)
            else -> throw RuntimeException("Invalid Mode '$mode'")
        }
    }

    fun run() {
        isRunning = true
        while (isRunning) {
            val op = program[pc]
            val arg1 = getMode(op / 100 % 10, program[pc + 1])
            val arg2 = getMode(op / 1000 % 10, program[pc + 2])
            val arg3 = getMode(op / 10000 % 10, program[pc + 3])
            when (op % 100) {
                1L -> addOp(arg1, arg2, arg3)
                2L -> multOp(arg1, arg2, arg3)
                3L -> inputOp(arg1, arg2, arg3)
                4L -> outputOp(arg1, arg2, arg3)
                5L -> jnzOp(arg1, arg2, arg3)
                6L -> jzOp(arg1, arg2, arg3)
                7L -> lessOp(arg1, arg2, arg3)
                8L -> equalOp(arg1, arg2, arg3)
                9L -> setBaseOp(arg1, arg2, arg3)
                99L -> haltOp(arg1, arg2, arg3)
                else -> throw RuntimeException("Invalid Operator '$op'")
            }
        }
    }
}


fun readInput(file: String): List<Long> {
    return File(file).readText().split(",").map { it.trim() }.map { it.toLong() }
}

@Suppress("UNUSED_PARAMETER")
fun main(args: Array<String>) {
    val res = readInput("input.txt")
    val peter = Interpreter(Memory(res))
    peter.run()
}