# Intcomputer Specs

## Capabilities

Memory is allowed to be larger than initial program but address is never less than zero.

Memory not contained in the initial program is assumed to be 0.

Large numbers should be handled. (50 bits at least?)

## Opcodes

| opcode | instruction          | signature                                 |
| ------ | -------------------- | ----------------------------------------- |
| 01     | Add                  | a1, a2 -> a3                              |
| 02     | Multiply             | a1, a2 -> a3                              |
| 03     | Read input           | _ -> a1                                   |
| 04     | Print Output         | a1 -> _                                   |
| 05     | JNZ                  | conditional, target-pc -> _               |
| 06     | JZ                   | conditional, target-pc -> _               |
| 07     | Less than            | smaller, larger -> 1 if true else 0 in a3 |
| 08     | Equals               | a1, a2 -> 1 if true else 0 in a3          |
| 09     | Adjust relative base | a1 -> increase relative base by a1        |
| 99     | Halt                 | _ -> _                                    |

## Parameter modes

| code | mode                                      |
| ---- | ----------------------------------------- |
| 0    | Position Mode                             |
| 1    | Immediate Mode - signed integer           |
| 2    | Relative mode                             |


## Intstruction Structure

> A B C DE

- DE: two-digit opcode
- C:  mode of first parameter
- B:  mode of second parameter
- A:  mode of third parameter

Leading zeros can be skipped.

