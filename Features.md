Below are the new features included in my smart contract:

## 1.Review Quest
```
The "Review Quest" feature allows the Stackup admin to review and mark a quest as completed by a player. After a player submits a quest for review, the reviewQuest function is called by the admin to finalize the process.
This function ensures that the player has successfully submitted the quest by checking their quest status.
By reviewing quest completion, this feature serves several purposes. It ensures fair gameplay by preventing players from claiming rewards without meeting the quest requirements.
It also adds an element of trust and credibility to Stackup, as the admin's review assures other players that quests are genuinely completed.
```
## 2.Claiming ERC-20 Token Rewards
```
The "Claiming ERC-20 Token Rewards" feature enables players to receive their rewards in the form of ERC-20 tokens.
The implementation involves interacting with an external ERC-20 token contract using the IERC20 interface. 
The contract address of the ERC-20 token is provided, and the claimRewards function facilitates the transfer of tokens from the Stackup contract to the player.
To ensure a secure and reliable transfer, the function performs several checks. First, it verifies that the player has completed and reviewed the quest by checking their quest status.
Additionally, it ensures that rewards have not been claimed multiple times. The function then initiates the transfer by invoking the transfer function of the ERC-20 token contract,
sending the specified token amount to the player's address.
By incorporating these features, Stackup enhances the player experience by providing tangible rewards in the form of widely accepted ERC-20 tokens.
Players can accumulate tokens as they progress through quests, providing a sense of achievement and value within Stackup's ecosystem. 
The "Review Quest" feature adds an additional layer of trust and fairness, ensuring that rewards are allocated only to players who have successfully completed the quests.
```
