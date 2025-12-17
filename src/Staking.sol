
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FinnexceStaking is ReentrancyGuard, Ownable {
using SafeERC20 for IERC20;

/*//////////////////////////////////////////////////////////////
STATE
//////////////////////////////////////////////////////////////*/

IERC20 public stakingToken;
IERC20 public rewardToken;
address public core;

uint256 public rewardRate; // reward per second
uint256 public lastUpdateTime;
uint256 public rewardPerTokenStored;
uint256 public totalStaked;

mapping(address => uint256) public userStaked;
mapping(address => uint256) public userRewardPerTokenPaid;
mapping(address => uint256) public rewards;

/*//////////////////////////////////////////////////////////////
EVENTS
//////////////////////////////////////////////////////////////*/

event Staked(address indexed user, uint256 amount);
event Withdrawn(address indexed user, uint256 amount);
event RewardPaid(address indexed user, uint256 reward);
event RewardRateUpdated(uint256 newRate);
event RewardFunded(uint256 amount);
event CoreSet(address core);

/*//////////////////////////////////////////////////////////////
CONSTRUCTOR
//////////////////////////////////////////////////////////////*/

constructor(address _stakingToken, uint256 _rewardRate)
Ownable(msg.sender)
{
require(_stakingToken != address(0), "INVALID_TOKEN");

stakingToken = IERC20(_stakingToken);
rewardToken = IERC20(_stakingToken);
rewardRate = _rewardRate;
lastUpdateTime = block.timestamp;
}

/*//////////////////////////////////////////////////////////////
MODIFIERS
//////////////////////////////////////////////////////////////*/

modifier onlyCore() {
require(msg.sender == core, "ONLY_CORE");
_;
}

modifier updateReward(address account) {
rewardPerTokenStored = rewardPerToken();
lastUpdateTime = block.timestamp;

if (account != address(0)) {
rewards[account] = earned(account);
userRewardPerTokenPaid[account] = rewardPerTokenStored;
}
_;
}

/*//////////////////////////////////////////////////////////////
VIEW FUNCTIONS
//////////////////////////////////////////////////////////////*/

function rewardPerToken() public view returns (uint256) {
if (totalStaked == 0) return rewardPerTokenStored;

uint256 timeElapsed = block.timestamp - lastUpdateTime;
return rewardPerTokenStored +
(rewardRate * timeElapsed * 1e18) / totalStaked;
}

function earned(address account) public view returns (uint256) {
return
(userStaked[account] *
(rewardPerToken() - userRewardPerTokenPaid[account])) /
1e18 +
rewards[account];
}

/*//////////////////////////////////////////////////////////////
CORE → STAKING FUNCTIONS
//////////////////////////////////////////////////////////////*/

function stakeFor(address user, uint256 amount)
external
onlyCore
nonReentrant
updateReward(user)
{
require(amount > 0, "STAKE_0");

totalStaked += amount;
userStaked[user] += amount;

stakingToken.safeTransferFrom(user, address(this), amount);

emit Staked(user, amount);
}

function withdrawFor(address user, uint256 amount)
external
onlyCore
nonReentrant
updateReward(user)
{
require(amount > 0, "WITHDRAW_0");
require(userStaked[user] >= amount, "INSUFFICIENT");

totalStaked -= amount;
userStaked[user] -= amount;

stakingToken.safeTransfer(user, amount);

emit Withdrawn(user, amount);
}

function claimFor(address user)
external
onlyCore
nonReentrant
updateReward(user)
{
uint256 reward = rewards[user];
require(reward > 0, "NO_REWARD");

rewards[user] = 0;
rewardToken.safeTransfer(user, reward);

emit RewardPaid(user, reward);
}

/*//////////////////////////////////////////////////////////////
OWNER FUNCTIONS
//////////////////////////////////////////////////////////////*/

function setCore(address _core) external onlyOwner {
require(_core != address(0), "INVALID_CORE");
core = _core;
emit CoreSet(_core);
}

function fundRewards(uint256 amount) external onlyOwner {
require(amount > 0, "INVALID_AMOUNT");
rewardToken.safeTransferFrom(msg.sender, address(this), amount);
emit RewardFunded(amount);
}

function setRewardRate(uint256 _rate) external onlyOwner {
rewardRate = _rate;
emit RewardRateUpdated(_rate);
}
}
