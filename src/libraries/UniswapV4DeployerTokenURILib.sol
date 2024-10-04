// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Base64} from "openzeppelin-contracts/contracts/utils/Base64.sol";

/// @title TokenURILib
/// @notice A library to generate the tokenURI for the UniswapV4DeployerCompetition contract
library TokenURILib {
    function tokenURI() internal pure returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            "Uniswap V4 Deployer",
                            '", "description":"',
                            "I deployed the UniswapV4 contract with a sick address",
                            '", "image": "',
                            "ipfs://QmTZeKgupCJNwMek2AoNEYR1pmjqYiS6MgddadH3RKPXvA/v4nft.svg",
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
