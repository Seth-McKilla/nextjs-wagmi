// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract SubDAOPostNFTFactory is ERC721Enumerable, AccessControl {
    bytes32 public constant SUB_PRESIDENT_ROLE = keccak256("SUB_PRESIDENT_ROLE");
    bytes32 public constant SUB_VICE_PRESIDENT_ROLE = keccak256("SUB_VICE_PRESIDENT_ROLE");
    bytes32 public constant SUB_SECRETARY_ROLE = keccak256("SUB_SECRETARY_ROLE");

    // Mapping from token ID to post details
    mapping(uint256 => string) private _postDetails;

    constructor() ERC721("SubDAO Post NFT", "SDPNFT") {
        _setupRole(SUB_PRESIDENT_ROLE, msg.sender); // Assigning the deployer as the initial sub-president for example purposes
    }

    function supportsInterface(bytes4 interfaceId) 
        public view 
        virtual 
        override(ERC721Enumerable, AccessControl) 
        returns (bool) 
    {
        return super.supportsInterface(interfaceId) || super.supportsInterface(interfaceId);
    }

    function createPost(string memory details) external returns (uint256) {
        uint256 newPostId = totalSupply() + 1;
        _mint(msg.sender, newPostId);
        _postDetails[newPostId] = details;
        return newPostId;
    }

    function getPostDetails(uint256 postId) external view returns (string memory) {
        return _postDetails[postId];
    }

    function updatePostDetails(uint256 postId, string memory newDetails) external {
        require(ownerOf(postId) == msg.sender, "Not the owner of the post");
        _postDetails[postId] = newDetails;
    }

    // Sub-President Functions
    function burnPostAsPresident(uint256 postId) external onlyRole(SUB_PRESIDENT_ROLE) {
        _burn(postId);
    }

    // Sub-Vice President Functions
    function transferPostOwnershipAsVicePresident(uint256 postId, address newOwner) external onlyRole(SUB_VICE_PRESIDENT_ROLE) {
        _transfer(ownerOf(postId), newOwner, postId);
    }

    // Sub-Secretary Functions
    function approvePostTransferAsSecretary(uint256 postId, address approvedAddress) external onlyRole(SUB_SECRETARY_ROLE) {
        _approve(approvedAddress, postId);
    }
}