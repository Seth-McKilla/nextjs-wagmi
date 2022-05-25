// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;
import "@openzeppelin/contracts/utils/Counters.sol";

contract BetMain {
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

    //@dev this function will supply initial amount to account and to mapping betWinnerAmountClaimable
    function setbetWinnerAmountClaimable(address claimableAddress)
        public
        payable
        onlyOwner
    {
        betWinnerAmountClaimable[claimableAddress] += msg.value;
    }

    function checkAndAllotFunds(uint256 betAmount) private {
        uint256 existingBalance = betWinnerAmountClaimable[msg.sender] || 0;
        uint256 existingBalancePlusBetAmount = existingBalance + msg.value;

        require(
            existingBalancePlusBetAmount >= betAmount || existingBalance >= betAmount,
            "Please enter appropriate amount"
        );

        if (existingBalance >= betAmount) {
            // existing will be used, so reducing only required amount
            betWinnerAmountClaimable[msg.sender] -= betAmount;
        } else {
            // existing + msg.value will be used, so setting 0
            betWinnerAmountClaimable[msg.sender] = 0;
        }
    }

    //@dev  This fucntion create bets for exsisiting match Ids
    //
    function _createBet(
        uint256 _betAmount,
        uint256 _matchId,
        string memory _teamName
    ) external payable {

        checkAndAllotFunds(_betAmount);

        BetStruct memory newStruct = BetStruct(
            _matchId,
            _betIDs.current(),
            _betAmount,
            msg.sender,
            address(0),
            address(0),
            _teamName
        );
        betIdToStruct[_betIDs.current()] = newStruct;

        emit BetEventLauncher(
            _matchId,
            _betIDs.current(),
            _betAmount,
            msg.sender,
            address(0),
            address(0),
            _teamName
        );

        // We are not able to store  betIds.push(_betIDs.current()) with memory key word
        MatchStruct storage newMatchStruct = matchIdToMatchStruct[_matchId];
        newMatchStruct.betIds.push(_betIDs.current());
        _betIDs.increment();
    }

    //@dev People can join existing bets , for existing matchs, and bets
    function _joinBet(uint256 _matchId, uint256 _betId) external payable {
        BetStruct memory existingBetStruct = betIdToStruct[_betId];

        checkAndAllotFunds(existingBetStruct.betAmount);

        //update the betTaker
        existingBetStruct.betTakerAddress = msg.sender;
        existingBetStruct.betAmount = existingBetStruct.betAmount * 2;

        emit BetEventLauncher(
            existingBetStruct.matchId,
            existingBetStruct.betId,
            existingBetStruct.betAmount,
            existingBetStruct.betMakerAddress,
            existingBetStruct.betTakerAddress,
            existingBetStruct.betWinnerAddress,
            existingBetStruct.makerBetTeam
        );

        betIdToStruct[existingBetStruct.betId] = existingBetStruct;
    }

    //@dev this is an internal function to settle all the bets from particular maatch
    function _settleBet(uint256 _matchId) internal onlyOwner {
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

    // @dev This function decides the winningTeam for particular match
    function updateWinningTeam(uint256 _matchId, string memory winningTeam)
        external
        onlyOwner
    {
        require(
            abi.encodePacked(winningTeam).length != 0,
            "Please enter appropriate value for winning team"
        );

        MatchStruct memory newMatchStruct = matchIdToMatchStruct[_matchId];

        require(
            keccak256(abi.encodePacked(winningTeam)) == newMatchStruct.teamOne ||
            keccak256(abi.encodePacked(winningTeam)) == newMatchStruct.teamTwo,
            "Invalid Team Name Entered"
        );

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

    //@dev this fucntion can only be called by owners declared in the onlyOwner
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

    //@dev this fucntion anyone who wins to calim there winning amount
    //just after the match or collectively afterwards
    function claimYourWinning() external payable {
        require(
            betWinnerAmountClaimable[msg.sender] != 0,
            "You do not have any claimble amount"
        );
        payable(msg.sender).transfer(msg.value);
        betWinnerAmountClaimable[msg.sender] -= msg.value;
    }

    function withdrawFunds() external onlyOwner {
        // loop over all the betWinnerAmountClaimable and transfer the amount to the owner
        for (uint256 i = 0; i < betWinnerAmountClaimable.length; i++) {
            if (betWinnerAmountClaimable[i] != 0) {
                payable(i).transfer(betWinnerAmountClaimable[i]);
            }
        }
        payable(msg.sender).transfer(this.balance);
    }
}
