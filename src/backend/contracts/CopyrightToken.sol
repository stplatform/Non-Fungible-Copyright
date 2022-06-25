// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/ICopyrightGraph.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CopyrightToken is ICopyrightGraph, ERC721 {
    uint256 public tokenCount;

    uint256[] private _leafTokenIDs;
    mapping(uint256 => uint256) private _leafTokenIDIndex;

    mapping(uint256 => Token) private _idToTokens;
    mapping(uint256 => bool) private _idToPermissionToDistribute;
    mapping(uint256 => bool) private _idToPermissionToAdapteFrom;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor() ERC721("Test Copyright Token", "TCT") {
        _leafTokenIDs.push(0); // placeholder for the 0 index
    }

    /**
     * @dev Insert a new copyright token to the copyright graph.
     */
    function mint(uint256[] memory parentIds, uint256 tokenWeight) external {
        uint256 id = ++tokenCount;
        _safeMint(_msgSender(), id);
        _idToTokens[id].tokenWeight = tokenWeight;
        _idToTokens[id].timeStamp = block.timestamp;

        for (uint256 i = 0; i < parentIds.length; i++) {
            require(parentIds[i] != 0, "Parent token ID of a parent is zero.");
            require(_exists(parentIds[i]), "Parent token does not exist.");
            require(
                _idToPermissionToAdapteFrom[parentIds[i]],
                "Parent token does not allow adoption."
            );
        }

        if (parentIds.length > 0) {
            for (uint256 i = 0; i < parentIds.length; i++) {
                uint256 parentID = parentIds[i];
                Edge memory newEdge = Edge(
                    parentID,
                    _idToTokens[parentID].tokenWeight
                );
                _idToTokens[tokenCount].edges.push(newEdge);
                _idToTokens[tokenCount].numberOfTokensBehind++;

                if (_leafTokenIDIndex[parentID] != 0) {
                    uint256 parentIdx = _leafTokenIDIndex[parentID];
                    _leafTokenIDIndex[parentID] = 0;

                    _leafTokenIDIndex[id] = parentIdx;
                    _leafTokenIDs[parentIdx] = id;
                }
            }
        } else {
            _leafTokenIDs.push(id);
            _leafTokenIDIndex[id] = _leafTokenIDs.length - 1;
        }
    }

    /**
     * @dev Distribute copies with new ERC 721 token.
     */
    function distributeCopies(uint256 id) external returns (address) {
        require(
            _idToPermissionToDistribute[id],
            "The copyright owner does not allow distribution."
        );

        // TODO deploy a new ERC 721 for distribution and return the address
    }

    /**
     * @dev Deposit revenue to a copyright token and all inheriting copyright owners.
     */
    function deposit(uint256 id) external payable {
        require(_exists(id), "The token you make deposit to does not exist.");

        // TODO deposit and distribute the revenue. Use BFS and memory queue.
    }

    /**
     * @dev Change the permission of adoption from this copyright
     */
    function changeAdoptionPermission(uint256 id, bool permission) external {
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change permission."
        );
        _idToPermissionToAdapteFrom[id] = permission;
    }

    /**
     * @dev Change the permission of distrubute copies as NFT from this copyright
     */
    function changeDistributionPermission(uint256 id, bool permission)
        external
    {
        require(
            ownerOf(id) == msg.sender,
            "You don't have permission to change permission."
        );
        _idToPermissionToAdapteFrom[id] = permission;
    }

    // View functions

    function isIndependent(uint256 id) external view returns (bool) {
        return _leafTokenIDIndex[id] > 0;
    }

    function doAllowAdoption(uint256 id) external view returns (bool) {
        return _idToPermissionToAdapteFrom[id];
    }

    function doAllowDistribution(uint256 id) external view returns (bool) {
        return _idToPermissionToDistribute[id];
    }

    // For this demo, for simplicity, we don't need the following methods.

    function insertToken(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id,
        uint256 weight
    ) external {
        require(false, "Not implemented yet.");
    }

    function insertEdges(
        uint256[] memory parentIds,
        uint256[] memory parentWeights,
        uint256 id
    ) external {
        require(false, "Not implemented yet.");
    }

    function returnTime(uint256 id) external view returns (uint256 timeStamp) {
        require(false, "Not implemented yet.");
    }

    function returnTokenWeight(uint256 id)
        external
        view
        returns (uint256 weight)
    {
        require(false, "Not implemented yet.");
    }

    function returnIsBlacklisted(uint256 id)
        external
        view
        returns (bool isBlacklisted)
    {
        require(false, "Not implemented yet.");
    }

    function returnLeafTokenIDs()
        external
        view
        returns (uint256[] memory leafTokenIDs)
    {
        return _leafTokenIDs;
    }

    function changeTokenWeight(uint256 id, uint256 newWeight) external {
        require(false, "Not implemented yet.");
    }

    function blacklistToken(uint256 id, bool isBlacklisted) external {
        require(false, "Not implemented yet.");
    }

    function tokenExists(uint256 id) external view returns (bool exists) {
        require(false, "Not implemented yet.");
    }

    function returnId(Token memory token) external pure returns (uint256 id) {
        require(false, "Not implemented yet.");
    }
}
