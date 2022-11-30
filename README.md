Complete on-chain Roulette.

Connect MetaMask and deposit money or just make separate bets as blockchain transactions.

After exceed of Start Game Value Roulette starts to spin, chooses a number and you get the final result of your bet(s).

In case of winning Bet your balance will be increased on amount depends on your bet type.

You will always have access for all of your winnings because the owner of the Casino can't withdraw any amount if the contract itself doesn't have more liquidity than Owner's withdrawal amount PLUS All Players Winnings (Total sum of winning bets' amounts of all players).

If your winnings exceed total liquidity of the contract - you will get all this liquidity by withdrawal - and then you can even wait for liquidty from other players looses and withdraw the remaining amount after the first withdrawal.



Dev:
Bets are stored on-chain for each game (spin) and then they are removed from Bets array.

Contract is Consumer of VRF Subscription and getting trully random numbers from 0 to 36 via Request Randomness.

Contract is checking all bets for win or loose (matching with random number) and payouts needed amount for all winning bets to players' balances in the contract.

No owner's action can lead to a lack of liquidity for players. Winners can always wait for additional liquidity from not so lucky players or Owner (It's ok for him to provide additional liquidity to Contract because he will anyway win a little more often than loose in the long run due to roulette rules.(QUICK MATHS))