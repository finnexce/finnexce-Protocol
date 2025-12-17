// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFinnexceStaking {
    function stakeFor(address user, uint256 amount) external;
    function withdrawFor(address user, uint256 amount) external;
    function claimFor(address user) external;
}

contract FinnexceCoreV2 is Ownable {

    // ===== Addresses =====
    address public staking;
    address public treasury;

    // ===== Events =====
    event StakingUpdated(address staking);
    event TreasuryUpdated(address treasury);

    // ===== Admin =====
    constructor(address owner_) Ownable(owner_) {}

    function setStaking(address _staking) external onlyOwner {
        require(_staking != address(0), "INVALID_STAKING");
        staking = _staking;
        emit StakingUpdated(_staking);
    }

    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "INVALID_TREASURY");
        treasury = _treasury;
        emit TreasuryUpdated(_treasury);
    }

    // ===== User -> Core -> Staking =====
    function stake(uint256 amount) external {
        require(staking != address(0), "STAKING_NOT_SET");
        IFinnexceStaking(staking).stakeFor(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(staking != address(0), "STAKING_NOT_SET");
        IFinnexceStaking(staking).withdrawFor(msg.sender, amount);
    }

    function claim() external {
        require(staking != address(0), "STAKING_NOT_SET");
        IFinnexceStaking(staking).claimFor(msg.sender);
    }
}
