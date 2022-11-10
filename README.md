Connect wallet to site

Make a bet with value

Win or lose, balances refreshed

Can withdraw balance

Game starting only after certain amount in casino balance (checkupkeep)


Rules

bettype and number:

0: oneNumber: number,

1: twoNumbers: 0 for 1-2, 1 for 2-3, 2 for 4-5, 3 for 5-6, 4 for 7-8, 5 for 8-9, 6 for 10-11, 7 for 11-12, 8 for 13-14, 
9 for 14-15, 10 for 16-17, 11 for 17-18, 12 for 19-20, 13 for 20-21, 14 for 22-23, 15 for 23-24, 16 for 25-26, 17 for 26-27, 18 for 28-29, 19 for 29-30, 20 for 31-32, 21 for 32-33, 22 for 34-35, 23 for 35-36,          35:1

24 for 1-4, 25 for 2-5, 26 for 3-6, 27 for 4-7, 28 for 5-8, 29 for 6-9, 30 for 7-10, 31 for 8-11, 32 for 9-12, 33 for 10-13, 34 for 11-14, 35 for 12-15, 36 for 13-16, 37 for 14-17, 38 for 15-18, 39 for 16-19, 40 for 17-20, 41 for 18-21, 42 for 19-22, 43 for 20-23, 44 for 21-24, 45 for 22-25, 46 for 23-26, 47 for 24-27, 48 for 25-28, 49 for 26-29, 50 for 27-30, 51 for 28-31, 52 for 29-32, 53 for 30-33, 54 for 31-34, 55 for 32-35, 56 for 33-36,  
57 for 0-1, 58 for 0-2, 59 for 0-3,                                                                17:1


2: threeNumbers: 0 for 1-2-3, 1 for 4-5-6, 2 for 7-8-9, 3 for 10-11-12, 
4 for 13-14-15, 5 for 16-17-18, 6 for 19-20-21, 7 for 22-23-24, 
8 for 25-26-27, 9 for 28-29-30, 10 for 31-32-33, 11 for 34-35-36, 12 for 0-1-2, 13 for 0-2-3            11:1

3: fourNumbers: 0 for 1-2-4-5, 1 for 2-3-5-6 2 for 4-5-7-8, 
3 for 5-6-8-9, 4 for 7-8-10-11, 5 for 8-9-11-12, 
6 for 10-11-13-14, 7 for 11-12-14-15, 8 for 13-14-16-17, 
9 for 14-15-17-18, 10 for 16-17-19-20, 11 for 17-18-20-21,
12 for 19-20-22-23, 13 for 20-21-23-24, 14 for 22-23-25-26, 15 for 23-24-26-27, 16 for 25-26-28-29, 17 for 26-27-29-30, 18 for 28-29-31-32, 19 for 29-30-32-33, 20 for 31-32-34-35, 21 for 32-33-35-36, 22 for 0-1-2-3,             8:1

4: sixNumbers: 0 for 1-6, 1 for 7-12, 2 for 13-18, 3 for 19-24, 4 for 25-30, 5 for 31-36,        5:1

5: column: 0 for left, 1 for middle, 2 for right,     2:1 

6: dozen: 0 for first, 1 for second, 2 for third,     2:1

7: eighteen: 0 for low, 1 for high,     1:1
 
8: modulus: 0 for even, 1 for odd,      1:1

9: color: 0 for black, 1 for red,       1:1


Winning matrix 

if (rouletteWinNum == 0) {
    won == (bettype == 0 && number == 0) || 
    (bettype == 3 && number == 22) ||
    (bettype == 2 && (number == 12 || number == 13)) ||
    (bettype == 1 && (number == 57 || number == 58 || number == 59))
    
}
if (rouletteWinNum == 1) {
    won == (bettype == 0 && number == 1) ||
    (bettype == 9 && number == 1)  ||
    (bettype == 8 && number == 1)  ||
    (bettype == 7 && number == 0)  ||
    (bettype == 6 && number == 0)  ||
    (bettype == 5 && number == 0)  ||
    (bettype == 4 && number == 0)  ||
    (bettype == 3 && number == 0)  ||
    (bettype == 3 && number == 22) ||
    (bettype == 2 && number == 0)  ||
    (bettype == 1 && (number == 0 || number == 24)
}
if (rouletteWinNum == 2) {
    won == (bettype == 0 && number == 2) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 0) ||
    (bettype == 3 && (number == 0 || number == 1)) ||
    (bettype == 3 && number == 22) ||
    (bettype == 2 && number == 0)  ||
    (bettype == 1 && (number == 0 || number == 1 || number == 25)
}
if (rouletteWinNum == 3) {
    won == (bettype == 0 && number == 3) ||
    (bettype == 9 && number == 1)  ||
    (bettype == 8 && number == 1)  ||
    (bettype == 7 && number == 0)  ||
    (bettype == 6 && number == 0)  ||
    (bettype == 5 && number == 2)  ||
    (bettype == 4 && number == 0)  ||
    (bettype == 3 && number == 1)  ||
    (bettype == 3 && number == 22) ||
    (bettype == 2 && number == 0)  ||
    (bettype == 1 && (number == 1 || number == 26))
}
if (rouletteWinNum == 4) {
    won == (bettype == 0 && number == 4) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 0) ||
    (bettype == 3 && number == 2) ||
    (bettype == 2 && number == 1)  ||
    (bettype == 1 && (number == 2 || number == 24 || number == 27))
}
if (rouletteWinNum == 5) {
    won == (bettype == 0 && number == 5) ||
    (bettype == 9 && number == 1)  ||
    (bettype == 8 && number == 1)  ||
    (bettype == 7 && number == 0)  ||
    (bettype == 6 && number == 0)  ||
    (bettype == 5 && number == 1)  ||
    (bettype == 4 && number == 0)  ||
    (bettype == 3 && (number == 2 || number == 3))  ||
    (bettype == 2 && number == 1) ||
    (bettype == 1 && (number == 2 || number == 3 || number == 25 || number == 28)
}
if (rouletteWinNum == 6) {
    won == (bettype == 0 && number == 6) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 0) ||
    (bettype == 3 && number == 3) ||
    (bettype == 2 && number == 1)  ||
    (bettype == 1 && (number == 3 || number == 26 || number == 29))
}
if (rouletteWinNum == 7) {
    won == (bettype == 0 && number == 7) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && number == 4) ||
    (bettype == 2 && number == 2)  ||
    (bettype == 1 && (number == 4 || number == 27 || number == 30))
}
if (rouletteWinNum == 8) {
    won == (bettype == 0 && number == 8) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && (number == 4 || number == 5))  ||
    (bettype == 2 && number == 2) ||
    (bettype == 1 && (number == 4 || number == 5 || number == 28 || number == 31))
}
if (rouletteWinNum == 9) {
    won == (bettype == 0 && number == 9) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && number == 5) ||
    (bettype == 2 && number == 2)  ||
    (bettype == 1 && (number == 5 || number == 32))
}
if (rouletteWinNum == 10) {
    won == (bettype == 0 && number == 10) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && number == 6) ||
    (bettype == 2 && number == 3)  ||
    (bettype == 1 && (number == 6 || number == 27 || number == 30 || number == 33))
}
if (rouletteWinNum == 11) {
    won == (bettype == 0 && number == 11) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && (number == 6 || number == 7)) ||
    (bettype == 2 && number == 3) ||
    (bettype == 1 && (number == 6 || number == 7 || number == 26 || number == 31 || number == 34 ))

if (rouletteWinNum == 12) {
    won == (bettype == 0 && number == 12) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 0) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 1) ||
    (bettype == 3 && number == 7) ||
    (bettype == 2 && number == 3)  ||
    (bettype == 1 && (number == 7 || number == 32 || number == 35))
}
if (rouletteWinNum == 13) {
    won == (bettype == 0 && number == 13) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 2) ||
    (bettype == 3 && number == 8) ||
    (bettype == 2 && number == 4)  ||
    (bettype == 1 && (number == 8 || number == 30 || number == 33 || number == 36))
}
if (rouletteWinNum == 14) {
    won == (bettype == 0 && number == 14) ||
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
    won == (bettype == 0 && number == 15) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 2) ||
    (bettype == 3 && number == 9) ||
    (bettype == 2 && number == 4)  ||
    (bettype == 1 && (number == 9 || number == 35 || number == 38))
}
if (rouletteWinNum == 16) {
    won == (bettype == 0 && number == 16) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 2) ||
    (bettype == 3 && number == 10) ||
    (bettype == 2 && number == 5)  ||
    (bettype == 1 && (number == 10 || number == 36 || number == 39))
}
if (rouletteWinNum == 17) {
    won == (bettype == 0 && number == 17) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 2) ||
    (bettype == 3 && (number == 10 || number == 11))  ||
    (bettype == 2 && number == 5) ||
    (bettype == 1 && (number == 10 || number == 11 || number == 37 || number == 40))
}
if (rouletteWinNum == 18) {
    won == (bettype == 0 && number == 18) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 0) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 2) ||
    (bettype == 3 && number == 11)  ||
    (bettype == 2 && number == 5)  ||
    (bettype == 1 && (number == 11 || number == 38 || number == 41))
}
if (rouletteWinNum == 19) {
    won == (bettype == 0 && number == 19) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 3) ||
    (bettype == 3 && number == 12)  ||
    (bettype == 2 && number == 6)  ||
    (bettype == 1 && (number == 12 || number == 39 || number == 42))
}
if (rouletteWinNum == 20) {
    won == (bettype == 0 && number == 20) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 3) ||
    (bettype == 3 && (number == 12 || number == 13))  ||
    (bettype == 2 && number == 6) ||
    (bettype == 1 && (number == 12 || number == 13 || number == 40 || number == 43))
}
if (rouletteWinNum == 21) {
    won == (bettype == 0 && number == 21) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 3) ||
    (bettype == 3 && number == 13)  ||
    (bettype == 2 && number == 6)  ||
    (bettype == 1 && (number == 13 || number == 41 || number == 44))
}
if (rouletteWinNum == 22) {
    won == (bettype == 0 && number == 22) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 3) ||
    (bettype == 3 && number == 14)  ||
    (bettype == 2 && number == 7)  ||
    (bettype == 1 && (number == 14 || number == 42 || number == 45))
}
if (rouletteWinNum == 23) {
    won == (bettype == 0 && number == 23) ||
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
    won == (bettype == 0 && number == 24) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 1) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 3) ||
    (bettype == 3 && number == 15)||
    (bettype == 2 && number == 7)  ||
    (bettype == 1 && (number == 15 || number == 44 || number == 47))
}
if (rouletteWinNum == 25) {
    won == (bettype == 0 && number == 25) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 4) ||
    (bettype == 3 && number == 16)||
    (bettype == 2 && number == 8)  ||
    (bettype == 1 && (number == 16 || number == 45 || number == 48))
}
if (rouletteWinNum == 26) {
    won == (bettype == 0 && number == 26) ||
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
}
if (rouletteWinNum == 27) {
    won == (bettype == 0 && number == 27) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 4) ||
    (bettype == 3 && number == 17) ||
    (bettype == 2 && number == 8)  ||
    (bettype == 1 && (number == 17 || number == 47 || number == 50))
}
}
if (rouletteWinNum == 28) {
    won == (bettype == 0 && number == 28) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 4) ||
    (bettype == 3 && number == 18) ||
    (bettype == 2 && number == 9)  ||
    (bettype == 1 && (number == 18 || number == 48 || number == 51))
}
}
if (rouletteWinNum == 29) {
    won == (bettype == 0 && number == 29) ||
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
    won == (bettype == 0 && number == 30) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 4) ||
    (bettype == 3 && number == 19) ||
    (bettype == 2 && number == 9)  ||
    (bettype == 1 && (number == 19 || number == 50 || number == 53))
}
if (rouletteWinNum == 31) {
    won == (bettype == 0 && number == 31) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 5) ||
    (bettype == 3 && number == 20) ||
    (bettype == 2 && number == 10)  ||
    (bettype == 1 && (number == 20 || number == 51 || number == 54))
}
if (rouletteWinNum == 32) {
    won == (bettype == 0 && number == 32) ||
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
    won == (bettype == 0 && number == 33) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 5) ||
    (bettype == 3 && number == 21) ||
    (bettype == 2 && number == 10)  ||
    (bettype == 1 && (number == 21 || number == 53 || number == 56))
}
if (rouletteWinNum == 34) {
    won == (bettype == 0 && number == 34) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 0) ||
    (bettype == 4 && number == 5) ||
    (bettype == 3 && number == 22) ||
    (bettype == 2 && number == 11)  ||
    (bettype == 1 && (number == 22 || number == 54))
}
if (rouletteWinNum == 35) {
    won == (bettype == 0 && number == 35) ||
    (bettype == 9 && number == 0) ||
    (bettype == 8 && number == 1) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 1) ||
    (bettype == 4 && number == 5) ||
    (bettype == 3 && (number == 20 || number == 21))  ||
    (bettype == 2 && number == 11) ||
    (bettype == 1 && (number == 22 || number == 23 || number == 55))
}
if (rouletteWinNum == 36) {
    won == (bettype == 0 && number == 36) ||
    (bettype == 9 && number == 1) ||
    (bettype == 8 && number == 0) ||
    (bettype == 7 && number == 1) ||
    (bettype == 6 && number == 2) ||
    (bettype == 5 && number == 2) ||
    (bettype == 4 && number == 5) ||
    (bettype == 3 && number == 23) ||
    (bettype == 2 && number == 11)  ||
    (bettype == 1 && (number == 23 || number == 56))
}
