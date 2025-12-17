// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FinnexceCore is Ownable {

    // =========================
    // Treasury
    // =========================
    address public treasury;
    event TreasuryUpdated(address indexed treasury);

    // =========================
    // Pool structure
    // =========================
    struct Pool {
        address stakingContract;
        bool active;
    }

    Pool[] public pools;

    // =========================
    // Events
    // =========================
    event PoolCreated(uint256 indexed poolId, address stakingContract);
    event PoolStatusUpdated(uint256 indexed poolId, bool active);

    // =========================
    // Constructor
    // =========================
    constructor(address owner_) Ownable(owner_) {}

    // =========================
    // Pool Admin
    // =========================
    function createPool(address stakingContract) external onlyOwner {
        require(stakingContract != address(0), "INVALID_STAKING_CONTRACT");

        pools.push(
            Pool({
                stakingContract: stakingContract,
                active: false
            })
        );

        emit PoolCreated(pools.length - 1, stakingContract);
    }

    function setPoolActive(uint256 poolId, bool active) external onlyOwner {
        require(poolId < pools.length, "INVALID_POOL");
        pools[poolId].active = active;

        emit PoolStatusUpdated(poolId, active);
    }

    // =========================
    // Treasury Admin  
    // =========================
    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "INVALID_TREASURY");
        treasury = _treasury;
        emit TreasuryUpdated(_treasury);
    }

    // =========================
    // View helpers
    // =========================
    function poolCount() external view returns (uint256) {
        return pools.length;
    }
}
