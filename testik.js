let won = false
let rouletteWinNum = 0

let number = 0
let bettype = 0

if (rouletteWinNum == 0) {
	won =
		(bettype == 0 && number == 0) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && (number == 12 || number == 13)) ||
		(bettype == 1 && (number == 57 || number == 58 || number == 59))
}
if (rouletteWinNum == 1) {
	won =
		(bettype == 0 && number == 1) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 0) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 0 || number == 24))
}
if (rouletteWinNum == 2) {
	won =
		(bettype == 0 && number == 2) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && (number == 0 || number == 1)) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 0 || number == 1 || number == 25))
}
if (rouletteWinNum == 3) {
	won =
		(bettype == 0 && number == 3) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 1) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 1 || number == 26))
}
if (rouletteWinNum == 4) {
	won =
		(bettype == 0 && number == 4) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 2) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 2 || number == 24 || number == 27))
}
if (rouletteWinNum == 5) {
	won =
		(bettype == 0 && number == 5) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && (number == 2 || number == 3)) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 2 || number == 3 || number == 25 || number == 28))
}
if (rouletteWinNum == 6) {
	won =
		(bettype == 0 && number == 6) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 3) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 3 || number == 26 || number == 29))
}
if (rouletteWinNum == 7) {
	won =
		(bettype == 0 && number == 7) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 4) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 4 || number == 27 || number == 30))
}
if (rouletteWinNum == 8) {
	won =
		(bettype == 0 && number == 8) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && (number == 4 || number == 5)) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 4 || number == 5 || number == 28 || number == 31))
}
if (rouletteWinNum == 9) {
	won =
		(bettype == 0 && number == 9) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 5) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 5 || number == 32))
}
if (rouletteWinNum == 10) {
	won =
		(bettype == 0 && number == 10) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 6) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 && (number == 6 || number == 27 || number == 30 || number == 33))
}
if (rouletteWinNum == 11) {
	won =
		(bettype == 0 && number == 11) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && (number == 6 || number == 7)) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 &&
			(number == 6 || number == 7 || number == 26 || number == 31 || number == 34))
}
if (rouletteWinNum == 12) {
	won =
		(bettype == 0 && number == 12) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 7) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 && (number == 7 || number == 32 || number == 35))
}
if (rouletteWinNum == 13) {
	won =
		(bettype == 0 && number == 13) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 8) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 8 || number == 30 || number == 33 || number == 36))
}
if (rouletteWinNum == 14) {
	won =
		(bettype == 0 && number == 14) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && (number == 8 || number == 9)) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 8 || number == 9 || number == 34 || number == 37))
}
if (rouletteWinNum == 15) {
	won =
		(bettype == 0 && number == 15) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 9) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 9 || number == 35 || number == 38))
}
if (rouletteWinNum == 16) {
	won =
		(bettype == 0 && number == 16) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 10) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 10 || number == 36 || number == 39))
}
if (rouletteWinNum == 17) {
	won =
		(bettype == 0 && number == 17) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && (number == 10 || number == 11)) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 10 || number == 11 || number == 37 || number == 40))
}
if (rouletteWinNum == 18) {
	won =
		(bettype == 0 && number == 18) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 11) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 11 || number == 38 || number == 41))
}
if (rouletteWinNum == 19) {
	won =
		(bettype == 0 && number == 19) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 12) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 12 || number == 39 || number == 42))
}
if (rouletteWinNum == 20) {
	won =
		(bettype == 0 && number == 20) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && (number == 12 || number == 13)) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 12 || number == 13 || number == 40 || number == 43))
}
if (rouletteWinNum == 21) {
	won =
		(bettype == 0 && number == 21) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 13) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 13 || number == 41 || number == 44))
}
if (rouletteWinNum == 22) {
	won =
		(bettype == 0 && number == 22) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 14) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 14 || number == 42 || number == 45))
}
if (rouletteWinNum == 23) {
	won =
		(bettype == 0 && number == 23) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && (number == 14 || number == 15)) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 14 || number == 15 || number == 43 || number == 46))
}
if (rouletteWinNum == 24) {
	won =
		(bettype == 0 && number == 24) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 15) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 15 || number == 44 || number == 47))
}
if (rouletteWinNum == 25) {
	won =
		(bettype == 0 && number == 25) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 16) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 16 || number == 45 || number == 48))
}
if (rouletteWinNum == 26) {
	won =
		(bettype == 0 && number == 26) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && (number == 16 || number == 17)) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 16 || number == 17 || number == 46 || number == 49))
}

if (rouletteWinNum == 27) {
	won =
		(bettype == 0 && number == 27) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 17) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 17 || number == 47 || number == 50))
}

if (rouletteWinNum == 28) {
	won =
		(bettype == 0 && number == 28) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 18) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 18 || number == 48 || number == 51))
}

if (rouletteWinNum == 29) {
	won =
		(bettype == 0 && number == 29) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && (number == 18 || number == 19)) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 18 || number == 19 || number == 49 || number == 52))
}

if (rouletteWinNum == 30) {
	won =
		(bettype == 0 && number == 30) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 19) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 19 || number == 50 || number == 53))
}

if (rouletteWinNum == 31) {
	won =
		(bettype == 0 && number == 31) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 20) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 20 || number == 51 || number == 54))
}

if (rouletteWinNum == 32) {
	won =
		(bettype == 0 && number == 32) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && (number == 20 || number == 21)) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 20 || number == 21 || number == 52 || number == 55))
}

if (rouletteWinNum == 33) {
	won =
		(bettype == 0 && number == 33) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 21) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 21 || number == 53 || number == 56))
}

if (rouletteWinNum == 34) {
	won =
		(bettype == 0 && number == 34) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 22 || number == 54))
}

if (rouletteWinNum == 35) {
	won =
		(bettype == 0 && number == 35) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && (number == 20 || number == 21)) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 22 || number == 23 || number == 55))
}

if (rouletteWinNum == 36) {
	won =
		(bettype == 0 && number == 36) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 23) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 23 || number == 56))
}

console.log(won)
