// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.10;

import "src/interfaces/IHats.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "./DAOFactory.sol";

contract SubDAOFactory is DAOFactory {
    bytes32 public constant SUB_PRESIDENT_ROLE = keccak256("SUB_PRESIDENT_ROLE");
    bytes32 public constant SUB_VICE_PRESIDENT_ROLE = keccak256("SUB_VICE_PRESIDENT_ROLE");
    bytes32 public constant SUB_SECRETARY_ROLE = keccak256("SUB_SECRETARY_ROLE");

    constructor(address _hatsProtocolAddress) DAOFactory(_hatsProtocolAddress) {}

    // Sub-President Functions
    function subChangeHatImageURI(uint256 _hatId, string memory _newImageURI) external onlyRole(SUB_PRESIDENT_ROLE) {
        hatsProtocol.changeHatImageURI(_hatId, _newImageURI);
    }

    function subMakeHatImmutable(uint256 _hatId) external onlyRole(SUB_PRESIDENT_ROLE) {
        hatsProtocol.makeHatImmutable(_hatId);
    }

    // Sub-Vice President Functions
    function subRenounceHat(uint256 _hatId) external onlyRole(SUB_VICE_PRESIDENT_ROLE) {
        hatsProtocol.renounceHat(_hatId);
    }

    function subMintHat(uint256 _hatId, address _wearer) external onlyRole(SUB_VICE_PRESIDENT_ROLE) {
        hatsProtocol.mintHat(_hatId, _wearer);
    }

    // Sub-Secretary Functions
    function subGetHatToggleModule(uint256 _hatId) external onlyRole(SUB_SECRETARY_ROLE) view returns (address) {
        return hatsProtocol.getHatToggleModule(_hatId);
    }

    function subGetHatMaxSupply(uint256 _hatId) external onlyRole(SUB_SECRETARY_ROLE) view returns (uint32) {
        return hatsProtocol.getHatMaxSupply(_hatId);
    }

    function subGetImageURIForHat(uint256 _hatId) external onlyRole(SUB_SECRETARY_ROLE) view returns (string memory) {
        return hatsProtocol.getImageURIForHat(_hatId);
    }

    // Additional utility functions for the sub-DAO
    function subBatchMintHats(uint256[] calldata _hatIds, address[] calldata _wearers) external onlyRole(SUB_VICE_PRESIDENT_ROLE) returns (bool success) {
        return hatsProtocol.batchMintHats(_hatIds, _wearers);
    }

    function subViewHatDetails(uint256 _hatId) external onlyRole(SUB_SECRETARY_ROLE) view returns (
        string memory details,
        uint32 maxSupply,
        uint32 supply,
        address eligibility,
        address toggle,
        string memory imageURI,
        uint16 lastHatId,
        bool mutable_,
        bool active
    ) {
        return hatsProtocol.viewHat(_hatId);
    }
}