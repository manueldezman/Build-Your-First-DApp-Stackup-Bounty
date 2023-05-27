// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Stackup {
    enum PlayerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED,
        VERIFIED
    }

    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
    }

    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => PlayerQuestStatus)) public playerQuestStatuses;
    mapping(address => mapping(uint256 => bool)) public rewardsClaimed;

    constructor() {
        admin = msg.sender;
    }

     // Modifier to check if a quest exists
     modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }

    // Modifier to check if the caller is the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this operation");
        _;
    }

    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_
    ) external onlyAdmin {
        quests[nextQuestId] = Quest(nextQuestId, 0, title_, reward_, numberOfRewards_);
        nextQuestId++;
    }

    // Function for a player to join a quest
    function joinQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.NOT_JOINED,
            "Player has already joined/submitted this quest"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.JOINED;

        Quest storage thisQuest = quests[questId];
        thisQuest.numberOfPlayers++;
    }

    // Function for a player to submit a quest
    function submitQuest(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.JOINED,
            "Player must first join the quest"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.SUBMITTED;
    }

    // Function for the admin to verify quest completion
    function reviewQuest(uint256 questId) external onlyAdmin questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.SUBMITTED,
            "Player must submit the quest first"
        );
        playerQuestStatuses[msg.sender][questId] = PlayerQuestStatus.VERIFIED;
    }

    // Function for a player to claim rewards for a quest
    function claimRewards(uint256 questId) external questExists(questId) {
        require(
            playerQuestStatuses[msg.sender][questId] == PlayerQuestStatus.VERIFIED,
            "Player must complete and verify the quest"
        );
        require(
            rewardsClaimed[msg.sender][questId] == false,
            "Rewards already claimed"
        );

        Quest storage thisQuest = quests[questId];
        rewardsClaimed[msg.sender][questId] = true;

         // Assuming ERC-20 token contract is deployed on the Avalanche C-Chain
        IERC20 token = IERC20(address(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E));

        // Save the initial balance of the player before the transfer
        uint256 initialBalance = token.balanceOf(address(this));

        // Perform the transfer and capture the success or failure status
        bool transferSuccessful = token.transfer(msg.sender, thisQuest.reward);

        // Compare the final balance with the initial balance to check for any discrepancies
        uint256 finalBalance = token.balanceOf(address(this));
        bool balanceConsistent = finalBalance == initialBalance - thisQuest.reward;

        // Check if the transfer was successful and the balance is consistent
        require(transferSuccessful && balanceConsistent, "Token transfer failed");
    }
}
