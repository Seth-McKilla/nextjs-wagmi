pragma solidity ^0.8.19;

import "src/interfaces/IHats.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract DAOFactory is AccessControl {
    bytes32 public constant PRESIDENT_ROLE = keccak256("PRESIDENT_ROLE");
    bytes32 public constant VICE_PRESIDENT_ROLE = keccak256("VICE_PRESIDENT_ROLE");
    bytes32 public constant SECRETARY_ROLE = keccak256("SECRETARY_ROLE");

    IHats public hatsProtocol;

    constructor(address _hatsProtocolAddress) {
        _setupRole(PRESIDENT_ROLE, msg.sender); // Assigning the deployer as the initial president for example purposes
        hatsProtocol = IHats(_hatsProtocolAddress);
    }

    // President Functions
    function mintHatAsPresident(uint256 _hatId, address _wearer) external onlyRole(PRESIDENT_ROLE) returns (bool) {
        return hatsProtocol.mintHat(_hatId, _wearer);
    }

    function batchMintHatsAsPresident(uint256[] calldata _hatIds, address[] calldata _wearers) external onlyRole(PRESIDENT_ROLE) returns (bool) {
        return hatsProtocol.batchMintHats(_hatIds, _wearers);
    }

    function changeHatDetailsAsPresident(uint256 _hatId, string memory _newDetails) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol.changeHatDetails(_hatId, _newDetails);
    }

    function makeHatImmutableAsPresident(uint256 _hatId) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol.makeHatImmutable(_hatId);
    }

    function requestLinkTopHatToTreeAsPresident(uint32 _topHatId, uint256 _newAdminHat) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol.requestLinkTopHatToTree(_topHatId, _newAdminHat);
    }

}