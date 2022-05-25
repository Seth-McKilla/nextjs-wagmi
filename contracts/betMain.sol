// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Counters.sol";
import {Base64} from "./libraries/Base64.sol";

contract betMain {
    using Counters for Counters.Counter;
    Counters.Counter public _betIDs;
    Counters.Counter public match_id;
    uint256 baseBetValue = 10 ether;

    //mapping (address => uint) payabletoContract;
    address ownerOne = 0x65eb6D9b9Ff3F9999aF0cE71c6331A16Fc19f4b1;

    mapping(uint256 => MatchStruct) matches;

    struct MatchStruct {
        uint256 _matchId;
        string teamOne;
        string teamTwo;
        string winningTeam;
        uint256[] betIds;
    }
    //Mapping matchId to MatchStruct
    mapping(uint256 => MatchStruct) matchIdToMatchStruct;

    event MatchUpdateLauncher(
        uint256 matchId,
        string teamOne,
        string teamTwo,
        string winningTeam,
        uint256[] betIds
    );
    // Need to set this up
    uint256 currentUserWinAmount;

    struct BetStruct {
        uint256 matchId;
        uint256 betId;
        uint256 betAmount;
        address betMakerAddress;
        address betTakerAddress;
        address betWinnerAddress;
        string makerBetTeam;
    }

    event BetEventLauncher(
        uint256 matchId,
        uint256 betId,
        uint256 betAmount,
        address betMakerAddress,
        address betTakerAddress,
        address betWinnerAddress,
        string makerBetTeam
    );

    //BetStruct[] betsArray;
    //betId and BetStruct mapping
    mapping(uint256 => BetStruct) betIdToStruct;

    //winner address to Clamable amount
    mapping(address => uint256) betWinnerAmountClaimable;

    modifier onlyOwner() {
        require(ownerOne == msg.sender, "Only Owners modifier");
        _;
    }

    //@dev  This fucntion can be called by anyone having balance > 10 Matic
    //
    function _createBet(
        uint256 betAmount,
        uint256 _matchId,
        string memory _TeamName
    ) external payable {
        //require(msg.sender.balance >= baseBetValue && msg.sender.balance > betAmount, "Please check the wallet balance");

        // msg.value
        uint256 existingBalance = betWinnerAmountClaimable[msg.sender];

        if (existingBalance == 0) {
            require(msg.value != 0, "Please send appropriate amount");
        }

        uint256 existingBalanceAndValue = existingBalance + msg.value;

        if (existingBalance >= betAmount) {
            //existingBalance -= betAmount;
            if (!(betWinnerAmountClaimable[msg.sender] == 0)) {
                betWinnerAmountClaimable[msg.sender] -= betAmount;
            }
        } else if (existingBalanceAndValue == betAmount) {
            existingBalance -= existingBalance;
            if (!(betWinnerAmountClaimable[msg.sender] == 0)) {
                betWinnerAmountClaimable[msg.sender] -= 0;
            }
        } else {
            require(
                existingBalance >= betAmount ||
                    existingBalanceAndValue == betAmount,
                "Please enter appropriate amount"
            );
        }

        BetStruct memory newStruct = BetStruct(
            _matchId,
            _betIDs.current(),
            betAmount,
            msg.sender,
            address(0),
            address(0),
            _TeamName
        );
        betIdToStruct[_betIDs.current()] = newStruct;

        emit BetEventLauncher(
            _matchId,
            _betIDs.current(),
            betAmount,
            msg.sender,
            address(0),
            address(0),
            _TeamName
        );

        // We are not able to store  betIds.push(_betIDs.current()) with memory key word
        MatchStruct storage newMatchStruct = matchIdToMatchStruct[_matchId];
        newMatchStruct.betIds.push(_betIDs.current());
        _betIDs.increment();
    }

    //@dev anyone with balance greater than betAmount call this function to create bet
    function _joinBet(uint256 _matchId, uint256 _betId) external payable {
        BetStruct memory existingBetStruct = betIdToStruct[_betId];

        //require(msg.sender.balance >= baseBetValue && msg.sender.balance > existingBetStruct.betAmount, "Please check the wallet balance");

        uint256 existingBalance = betWinnerAmountClaimable[msg.sender];
        //uint256 existingBalanceAndValue = existingBetStruct.betAmount;

        if (existingBalance >= existingBetStruct.betAmount) {
            if (!(betWinnerAmountClaimable[msg.sender] == 0)) {
                betWinnerAmountClaimable[msg.sender] -= existingBetStruct
                    .betAmount;
            }
        } else if (existingBetStruct.betAmount > existingBalance) {
            if (!(betWinnerAmountClaimable[msg.sender] == 0)) {
                betWinnerAmountClaimable[msg.sender] -= existingBetStruct
                    .betAmount;
            }
        }

        //update the betTaker
        existingBetStruct = BetStruct(
            _matchId,
            existingBetStruct.betId,
            existingBetStruct.betAmount,
            existingBetStruct.betMakerAddress,
            msg.sender,
            address(0),
            existingBetStruct.makerBetTeam
        );

        emit BetEventLauncher(
            _matchId,
            existingBetStruct.betId,
            existingBetStruct.betAmount,
            existingBetStruct.betMakerAddress,
            msg.sender,
            address(0),
            existingBetStruct.makerBetTeam
        );

        betIdToStruct[_betIDs.current()] = existingBetStruct;
    }

    function _settleBet(uint256 _matchId) internal {
        MatchStruct memory newMatchStruct = matchIdToMatchStruct[_matchId];
        require(newMatchStruct.betIds.length > 0, "No bets Placed");

        for (uint256 j = 0; j < newMatchStruct.betIds.length; j++) {
            BetStruct memory newStruct = betIdToStruct[
                newMatchStruct.betIds[j]
            ];

            if (
                keccak256(abi.encodePacked(newStruct.makerBetTeam)) ==
                keccak256(abi.encodePacked(newMatchStruct.winningTeam))
            ) {
                newStruct.betWinnerAddress = newStruct.betMakerAddress;
                betWinnerAmountClaimable[newStruct.betWinnerAddress] +=
                    (newStruct.betAmount * 9) /
                    10;
            } else {
                newStruct.betWinnerAddress = newStruct.betTakerAddress;
                betWinnerAmountClaimable[newStruct.betWinnerAddress] +=
                    (newStruct.betAmount * 9) /
                    10;
            }

            emit BetEventLauncher(
                _matchId,
                newStruct.betId,
                newStruct.betAmount,
                newStruct.betMakerAddress,
                newStruct.betTakerAddress,
                newStruct.betWinnerAddress,
                newMatchStruct.winningTeam
            );
        }
    }

    function updateWinningTeam(uint256 _matchId, string memory winningTeam)
        external
        onlyOwner
    {
        require(
            abi.encodePacked(winningTeam).length != 0,
            "Please enter appropriate value for winning team"
        );
        MatchStruct memory newMatchStruct = matchIdToMatchStruct[_matchId];

        if (
            keccak256(abi.encodePacked(winningTeam)) ==
            keccak256(abi.encodePacked(newMatchStruct.teamOne))
        ) {
            newMatchStruct.winningTeam = newMatchStruct.teamOne;
        } else {
            newMatchStruct.winningTeam = newMatchStruct.teamTwo;
        }

        emit MatchUpdateLauncher(
            _matchId,
            newMatchStruct.teamOne,
            newMatchStruct.teamTwo,
            newMatchStruct.winningTeam,
            newMatchStruct.betIds
        );
        _settleBet(_matchId);
    }

    function _createMatchs(string memory _teamOne, string memory _teamTwo)
        external
        onlyOwner
    {
        require(
            abi.encodePacked(_teamOne).length != 0 &&
                abi.encodePacked(_teamTwo).length != 0,
            "Please enter appropriate data for teams"
        );

        require(
            abi.encodePacked(_teamOne).length !=
                abi.encodePacked(_teamTwo).length,
            "Please check the teams, how can a team play against itself"
        );

        uint256[] memory betArray;
        //matchIdsArr.push(_matchId);
        MatchStruct memory newMatchStruct = MatchStruct(
            match_id.current(),
            _teamOne,
            _teamTwo,
            "",
            betArray
        );

        emit MatchUpdateLauncher(
            match_id.current(),
            _teamOne,
            _teamTwo,
            "",
            betArray
        );
        matchIdToMatchStruct[match_id.current()] = newMatchStruct;
        match_id.increment();
    }
}
