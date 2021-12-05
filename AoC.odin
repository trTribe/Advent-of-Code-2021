package main

import "core:fmt"
import "core:os"
import "core:runtime"
import "core:reflect"

Day :: "3.2"
main :: proc() {
	when Day == "1.1" {
		DayOnePt1("input_1.txt")
	} when Day == "1.2" {
		DayOnePt2("input_1.txt")
	} when Day == "2.1" {
		DayTwoPt1("input_2.txt")
	} when Day == "2.2" {
		DayTwoPt2("input_2.txt")
	} when Day == "3.1" {
		DayThreePt1("input_3.txt")
	} when Day == "3.2" {
		DayThreePt2("input_3.txt")
	}
}

DayThreePt2 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		rowlen : uint = 0
		for r in text {
			if r != 13 {
				rowlen += 1
			} else {
				break
			}
		}
		rowlenCLRF := rowlen + 2

		OnesCount   := 0
		ZeroesCount := 0

		OnesLines:   [dynamic]u8
		ZeroesLines: [dynamic]u8
		OnesLineCount   := 0
		ZeroesLineCount := 0

		i : uint = 0
		for i < len(text) {
			r := text[i]
			if r == '1' {
				OnesCount += 1
				for o : uint = 0; o < rowlen; o += 1 {
					append(&OnesLines, text[i + o])
				}
				OnesLineCount += 1
			} else {
				ZeroesCount += 1
				for o : uint = 0; o < rowlen; o += 1 {
					append(&ZeroesLines, text[i + o])
				}
				ZeroesLineCount += 1
			}
			i += rowlenCLRF
		}

		FindNum :: proc(values: ^[dynamic]u8, rowlen: uint, i_org: uint, keepCommon: bool, defaultToRemove: u8) -> int {
			if uint(len(values)) == rowlen {
				v : = 0
				for r in values {
					v = (v * 2) + int(r - '0')
				}
				return v
			}

			if i_org == rowlen {
				fmt.println("No value found")
				return 0
			}

			OnesCount   := 0
			ZeroesCount := 0
			i := i_org
			for i < len(values) {
				r := values[i]
				if r == '1' {
					OnesCount += 1
				} else {
					ZeroesCount += 1
				}
				i += rowlen
			}

			runeToRemove : u8
			if OnesCount == ZeroesCount {
				runeToRemove = defaultToRemove
			} else if keepCommon && OnesCount > ZeroesCount || !keepCommon && OnesCount < ZeroesCount {
				runeToRemove = '0'
			} else {
				runeToRemove = '1'
			}

			row : uint = 0
			for row < len(values) {
				r := values[row + i_org]
				if r == runeToRemove {
					runtime.remove_range(values, int(row), int(row + rowlen))
				} else {
					row += rowlen
				}
			}

			return FindNum(values, rowlen, i_org + 1, keepCommon, defaultToRemove)
		}

		ox  := 0
		co2 := 0
		if OnesCount == ZeroesCount || OnesCount > ZeroesCount {
			ox  = FindNum(&OnesLines,   rowlen, 1, true,  '0')
			co2 = FindNum(&ZeroesLines, rowlen, 1, false, '1')
		} else {
			ox  = FindNum(&ZeroesLines, rowlen, 1, true,  '0')
			co2 = FindNum(&OnesLines,   rowlen, 1, false, '1')
		}

		fmt.println("Submarine life support rating:", ox * co2)
	} else {
		fmt.println("can't read the file", filename)
	}
}

DayThreePt1 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		rowlen : uint = 0
		for r in text {
			if r != 13 {
				rowlen += 1
			} else do break
		}

		gamma := 0
		delta := 0
		OnesCount   := make([]int, rowlen)
		ZeroesCount := make([]int, rowlen)
		bitIndex := 0
		for r in text {
			if r == 13 || r == 10 {
				bitIndex = 0
			} else {
				if r == '1' {
					OnesCount[bitIndex] += 1
				} else {
					ZeroesCount[bitIndex] += 1
				}
				bitIndex += 1
			}
		}

		for i : uint = 0; i < rowlen; i += 1 {
			gamma <<= 1
			delta <<= 1
			if OnesCount[i] > ZeroesCount[i] {
				gamma |= 1
			} else if OnesCount[i] < ZeroesCount[i] {
				delta |= 1
			} else {
				gamma |= 1
				delta |= 1
			}
		}

		fmt.println("Submarine power consumption:", gamma * delta)
	} else {
		fmt.println("can't read the file", filename)
	}
}

DayTwoPt2 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		horizontal := 0
		depth := 0
		aim := 0
		for i := 0; i < len(text); i += 1 {
			r := text[i]
			for text[i] != ' ' { i += 1 }
			i += 1
			v := 0
			for text[i] != 13 {
				v = (v * 10) + (int(text[i]) - '0')
				i += 1
				if i == len(text) do break
			}
			i += 1
			if r == 'f' {
				horizontal += v
				depth += aim * v
			} else if r == 'd' {
				aim += v
			} else if r == 'u' {
				aim -= v
			} else {
				fmt.println("illegal character found", r)
			}
 		}
		fmt.println("Final Submarine position:", horizontal * depth)
	} else {
		fmt.println("can't read the file", filename)
	}
}

DayTwoPt1 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		horizontal := 0
		depth := 0
		for i := 0; i < len(text); i += 1 {
			r := text[i]
			for text[i] != ' ' { i += 1 }
			i += 1
			v := 0
			for text[i] != 13 {
				v = (v * 10) + (int(text[i]) - '0')
				i += 1
				if i == len(text) do break
			}
			i += 1
			if r == 'f' {
				horizontal += v
			} else if r == 'd' {
				depth += v
			} else if r == 'u' {
				depth -= v
			} else {
				fmt.println("illegal character found", r)
			}
 		}
		fmt.println("Final Submarine position:", horizontal * depth)
	} else {
		fmt.println("can't read the file", filename)
	}
}

DayOnePt2 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		count := 0
		vs := [4]int{0, 0, 0, 0}
		i := 0
		for r in text {
			if r == 13 {
				if i < 3 {
					i += 1
				} else {
					sum1 := vs[0] + vs[1] + vs[2]
					sum2 := vs[1] + vs[2] + vs[3]
					if sum2 > sum1 {
						count += 1
					}
					vs[0] = vs[1]
					vs[1] = vs[2]
					vs[2] = vs[3]
					vs[3] = 0
				}
			} else if r != 10 {
				v := int(r) - '0'
				vs[i] *= 10
				vs[i] += v
			}
		}
		sum1 := vs[0] + vs[1] + vs[2]
		sum2 := vs[1] + vs[2] + vs[3]
		if sum2 > sum1 {
			count += 1
		}
		fmt.println("Number of Increases:", count)
	} else {
		fmt.println("can't read the file", filename)
	}
}

DayOnePt1 :: proc(filename: string) {
	text, success := os.read_entire_file_from_filename(filename)
	if success {
		count := 0
		v1 := 1 << 31 - 1
		v2 := 0
		for r in text {
			if r == 13 {
				if v2 > v1 {
					count += 1
				}
				v1 = v2
				v2 = 0
			} else if r != 10 {
				v := int(r) - '0'
				v2 *= 10
				v2 += v
			}
		}
		if v2 > v1 {
			count += 1
		}
		fmt.println("Number of Increases:", count)
	} else {
		fmt.println("can't read the file", filename)
	}
}