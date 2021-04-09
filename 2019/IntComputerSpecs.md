# Intcomputer Specs

## Capabilities

Memory is allowed to be larger than initial program but address is never zero.

## Opcodes

| opcode | instruction       | signature                                 |
| ------ | ----------------- | ----------------------------------------- |
| 01     | add               | a1, a2 -> a3                              |
| 02     | multiply          | a1, a2 -> a3                              |
| 03     | save intput       | _ -> a1                                   |
| 04     | output            | a1 -> _                                   |
| 05     | jnz               | conditional, target-pc -> _               |
| 06     | jz                | conditional, target-pc -> _               |
| 07     | less than         | smaller, larger -> 1 if true else 0 in a3 |
| 08     | equals            | a1, a2 -> 1 if true else 0 in a3          |
| 09     | set relative base | a1 -> increase relative base by a1        |
| 99     | exit              | _ -> _                                    |

## Parameter modes

| code | mode                                      |
| ---- | ----------------------------------------- |
| 0    | Position Mode                             |
| 1    | Immediate Mode - signed integer           |
| 2    | Relative mode                             |


## Intstruction Structure

A B C DE

DE: two-digit opcode
C:  mode of first parameter
B:  mode of second parameter
A:  mode of third parameter

Leading zeros can be skipped.

### Pitfalls

Normally, after an instruction is finished, the instruction pointer increases by the number of values in that instruction. *However*, if the instruction modifies the instruction pointer, that value is used and the instruction pointer is *not automatically increased*
