pragma solidity ^0.8.19;

import "src/interfaces/IHats.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";

contract DAO is AccessControl {
    bytes32 public constant PRESIDENT_ROLE = keccak256("PRESIDENT_ROLE");
    bytes32 public constant VICE_PRESIDENT_ROLE =
        keccak256("VICE_PRESIDENT_ROLE");
    bytes32 public constant SECRETARY_ROLE = keccak256("SECRETARY_ROLE");

    //track the deployed contract address of the DAOMembershipNFT contract
    address public daoProposalAddress;

    //track the top hat id of the DAO
    uint256 public topHatId;

    IHats public hatsProtocol;

    constructor(
        address _hatsProtocolAddress,
        string memory _details,
        string memory _imageURI
    ) {
        _setupRole(PRESIDENT_ROLE, tx.origin); // Assigning the deployer as the 3initial president for example purposes
        hatsProtocol = IHats(_hatsProtocolAddress);
        topHatId = hatsProtocol.mintTopHat(tx.origin, _details, _imageURI);
    }

    //set dao proposal address to a new address
    function setDAOProposalAddress(
        address _newDAOProposalAddress
    ) external onlyRole(PRESIDENT_ROLE) {
        daoProposalAddress = _newDAOProposalAddress;
    }

    //set the address of the hats protocol contract
    function setHatsProtocolAddress(
        address _newHatsProtocolAddress
    ) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol = IHats(_newHatsProtocolAddress);
    }

    function createHatAsPresident(
        string calldata _details,
        uint32 _maxSupply,
        address _eligibility,
        address _toggle,
        bool _mutable,
        string calldata _imageURI
    ) external onlyRole(PRESIDENT_ROLE) returns (uint256 newHatId) {
        return
            hatsProtocol.createHat(
                topHatId,
                _details,
                _maxSupply,
                _eligibility,
                _toggle,
                _mutable,
                _imageURI
            );
    }

    function batchCreateHatsAsPresident(
        string[] calldata _details,
        uint32[] calldata _maxSupplies,
        address[] memory _eligibilityModules,
        address[] memory _toggleModules,
        bool[] calldata _mutables,
        string[] calldata _imageURIs
    ) external onlyRole(PRESIDENT_ROLE) returns (bool success) {
        //based on te number of hats to be created, create an array of the top hat id that are all the same
        uint256[] memory _admins = new uint256[](_details.length);
        for (uint256 i = 0; i < _details.length; i++) {
            _admins[i] = topHatId;
        }
        return
            hatsProtocol.batchCreateHats(
                _admins,
                _details,
                _maxSupplies,
                _eligibilityModules,
                _toggleModules,
                _mutables,
                _imageURIs
            );
    }

    function mintHatAsPresident(
        uint256 _hatId,
        address _wearer
    ) external onlyRole(PRESIDENT_ROLE) returns (bool) {
        return hatsProtocol.mintHat(_hatId, _wearer);
    }

    function batchMintHatsAsPresident(
        uint256[] calldata _hatIds,
        address[] calldata _wearers
    ) external onlyRole(PRESIDENT_ROLE) returns (bool) {
        return hatsProtocol.batchMintHats(_hatIds, _wearers);
    }

    function changeHatDetailsAsPresident(
        uint256 _hatId,
        string memory _newDetails
    ) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol.changeHatDetails(_hatId, _newDetails);
    }

    //allow change of DAOProposal contract address
    function changeDAOProposalAddress(
        address _newDAOProposalAddress
    ) external onlyRole(PRESIDENT_ROLE) {
        daoProposalAddress = _newDAOProposalAddress;
    }

    //allow link top hat request
    function approveLinkTopHatToTreeAsPresident(
        uint32 _topHatId,
        uint256 _newAdminHat,
        address _eligibility,
        address _toggle,
        string calldata _details,
        string calldata _imageURI
    ) external onlyRole(PRESIDENT_ROLE) {
        hatsProtocol.approveLinkTopHatToTree(
            _topHatId,
            _newAdminHat,
            _eligibility,
            _toggle,
            _details,
            _imageURI
        );
    }
}
