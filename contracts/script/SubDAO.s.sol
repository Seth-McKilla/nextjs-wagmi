// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {SubDAO} from "../src/SubDAO.sol";

contract DeployDAO is Script {
    string public constant _DAOimageURI =
        "ipfs://bafkreiflezpk3kjz6zsv23pbvowtatnd5hmqfkdro33x5mh2azlhne3ah4";

    string public constant _DAODetails =
        "ipfs://bafkreiflezpk3kjz6zsv23pbvowtatnd5hmqfkdro33x5mh2azlhne3ah4";

    address public constant _hatsProtocolAddress =
        0x45dBf47CDb1C0e90DE7778eDA82244f2e50f281b;

    uint256 hatId = 0;

    string[] public _details = ["President", "Vice President"];
    uint32[] public _maxSupplies = [1, 1];
    address[] public _eligibilityModules = [
        0x0000000000000000000000000000000000004A75,
        0x0000000000000000000000000000000000004A75
    ];
    address[] public _toggleModules = [
        0x0000000000000000000000000000000000004A75,
        0x0000000000000000000000000000000000004A75
    ];
    bool[] public _mutables = [true, true];
    string[] public _imageURIs = ["", ""];

    string public _detail = "President";
    uint32 public _maxSupply = 1;
    address public _eligibility = 0x0000000000000000000000000000000000004A75;
    address public _toggle = 0x0000000000000000000000000000000000004A75;
    bool public _mutable = true;
    string public _imageURI = "";

    bytes32 internal constant SALT = bytes32(abi.encode(0x436c756244414f)); // ~     C(43) l(6c) u(75) b(62) D(44) A(41) O(4f)

    function run() external {
        // set up deployer
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);
        // log deployer data
        console2.log("Deployer: ", deployer);
        console2.log("Deployer Nonce: ", vm.getNonce(deployer));

        vm.startBroadcast(deployer);

        // deploy Hats to a deterministic address via CREATE2
        SubDAO dao = new SubDAO{salt: SALT}(
            _hatsProtocolAddress,
            _DAODetails,
            _DAOimageURI
        );
        //view top hat id in dao
        console2.log("Top Hat ID: ", dao.topHatId());
        // create hats
        // hatId = dao.createHatAsPresident(
        //     _detail,
        //     _maxSupply,
        //     _eligibility,
        //     _toggle,
        //     _mutable,
        //     _imageURI
        // );
        // console2.log("Hat ID: ", hatId);
        // mint hats

        vm.stopBroadcast();
        // log deployment data
        console2.log("Salt: ", vm.toString(SALT));
        console2.log("DAO contract: ", address(dao));
        //remember DAO address
        // vm.startBroadcast(deployer);
        // // dao.batchCreateHatsAsPresident(_details, _maxSupplies, _eligibilityModules, _toggleModules, _mutables, _imageURIs);
        // dao.createHatAsPresident(_detail, _maxSupply, _eligibility, _toggle, _mutable, _imageURI);
        // vm.stopBroadcast();
    }

    // function createHats() external {
    //     DAO dao = DAO(vm.envAddress("DAO_ADDRESS"));
    //     dao.createHatAsPresident(_detail, _maxSupply, _eligibility, _toggle, _mutable, _imageURI);
    //     // vm.startBroadcast(deployer);
    //     // // dao.batchCreateHatsAsPresident(_details, _maxSupplies, _eligibilityModules, _toggleModules, _mutables, _imageURIs);
    //     // dao.createHatAsPresident(_detail, _maxSupply, _eligibility, _toggle, _mutable, _imageURI);
    //     // vm.stopBroadcast();
    // }

    // forge script script/DAO.s.sol:DeployDAO -f optimismGoerli --broadcast --verify
}

// contract DeployHatsAndMintTopHat is Script {
//     string public imageURI = "";
//     string public name = "Hats Protocol - Test XYZ";
//     bytes32 internal constant SALT = bytes32(abi.encode(0x4a15)); // ~ hats

//     function run() external {
//         uint256 privKey = vm.envUint("PRIVATE_KEY");

//         address deployer = vm.rememberKey(privKey);
//         vm.startBroadcast(deployer);

//         Hats hats = new Hats{salt: SALT}(name, imageURI);

//         string memory image = "";
//         string memory details = "";

//         uint256 tophat = hats.mintTopHat(deployer, details, image);

//         vm.stopBroadcast();

//         console2.log("hats: ", address(hats));
//         console2.log("tophat: ", tophat);
//     }

//     // forge script script/Hats.s.sol:DeployHatsAndMintTopHat -f goerli
//     // forge script script/Hats.s.sol:DeployHatsAndMintTopHat -f polygon --broadcast --verify

//     // forge script script/Hats.s.sol:DeployHatsAndMintTopHat --rpc-url http://localhost:8545 --broadcast

//     // forge verify-contract --chain-id 5 --num-of-optimizations 1000000 --watch --constructor-args $(cast abi-encode "constructor(string,string)" "Hats Protocol - uri test 7" "") --compiler-version v0.8.16 "0x9b50ab91b3ffbcdd5d5ed49ed70bf299434c955c" src/Hats.sol:Hats $ETHERSCAN_API
// }
