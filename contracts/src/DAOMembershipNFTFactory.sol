// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Importing the ERC1155 standard and other necessary contracts from OpenZeppelin
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Counters.sol";

/**
 * @title DAOMembershipNFTFactory
 * @dev This contract allows for the creation of DAO membership NFTs that are soulbound to an address.
 * It uses the ERC-1155 standard, which supports both fungible and non-fungible tokens.
 */
contract DAOMembershipNFTFactory is ERC1155, Ownable {
    using Counters for Counters.Counter; // Using the Counters library for managing token IDs

    // Counter for generating unique token IDs
    Counters.Counter private _tokenIds;

    // Mapping from token ID to its soulbound address
    mapping(uint256 => address) private _soulboundAddresses;

    /**
     * @dev Constructor that sets the metadata URI for the tokens.
     * The metadata for each token would be fetched from this endpoint by replacing `{id}` with the actual token ID.
     */
    constructor() ERC1155("https://yourapi.com/api/token/{id}.json") {}

    /**
     * @dev Allows the owner (presumably the DAO) to mint new membership NFTs.
     * Each NFT is soulbound to the specified address.
     * @param account Address to which the NFT will be soulbound.
     * @param amount Amount of NFTs to mint.
     * @return The ID of the minted NFT.
     */
    function createMembershipNFT(address account, uint256 amount) external onlyOwner returns (uint256) {
        _tokenIds.increment(); // Incrementing the token ID counter
        uint256 newTokenId = _tokenIds.current(); // Getting the current token ID
        _mint(account, newTokenId, amount, ""); // Minting the NFT
        _soulboundAddresses[newTokenId] = account; // Setting the soulbound address for the NFT
        return newTokenId;
    }

    /**
     * @dev Checks if a token is soulbound to a specific address.
     * @param tokenId ID of the token to check.
     * @param account Address to check against.
     * @return True if the token is soulbound to the address, false otherwise.
     */
    function isSoulbound(uint256 tokenId, address account) external view returns (bool) {
        return _soulboundAddresses[tokenId] == account;
    }

    /**
     * @dev Overrides the default transfer function of ERC-1155 to ensure that tokens can only be transferred to their soulbound addresses.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
        require(_soulboundAddresses[id] == to, "ERC1155: Can only transfer to the soulbound address");
        super.safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev Overrides the default batch transfer function of ERC-1155 to ensure that tokens can only be transferred to their soulbound addresses.
     */
    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public override {
        for (uint256 i = 0; i < ids.length; ++i) {
            require(_soulboundAddresses[ids[i]] == to, "ERC1155: Can only transfer to the soulbound address");
        }
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }
}