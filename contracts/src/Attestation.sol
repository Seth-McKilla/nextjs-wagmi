// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Attestation contract for handling bounty attestations and subDAO creation attestations.
contract AttestationContract {

    // Struct for a bounty attestation.
    struct BountyAttestation {
        address attestor;     // Address of the entity making the attestation.
        string details;       // Details or description of the attestation.
        uint256 timestamp;    // Timestamp when the attestation was made.
    }

    // Struct for a subDAO creation attestation.
    struct SubDAOAttestation {
        address creator;      // Address of the subDAO creator.
        string subDAOName;    // Name or identifier of the subDAO.
        uint256 timestamp;    // Timestamp when the subDAO was created.
    }

    // Mapping to store bounty attestations. The key is a unique identifier for the bounty.
    mapping(uint256 => BountyAttestation) public bountyAttestations;

    // Mapping to store subDAO creation attestations. The key is the address of the subDAO.
    mapping(address => SubDAOAttestation) public subDAOAttestations;

    // Event emitted when a bounty attestation is made.
    event BountyAttested(uint256 bountyId, address attestor, string details);

    // Event emitted when a subDAO creation attestation is made.
    event SubDAOCreated(address creator, string subDAOName);

    // Function to attest to a bounty.
    function attestBounty(uint256 bountyId, string memory details) external {
        // Create a new bounty attestation.
        BountyAttestation memory newAttestation = BountyAttestation({
            attestor: msg.sender,
            details: details,
            timestamp: block.timestamp
        });

        // Store the attestation in the mapping.
        bountyAttestations[bountyId] = newAttestation;

        // Emit the event.
        emit BountyAttested(bountyId, msg.sender, details);
    }

    // Function to attest to the creation of a subDAO.
    function attestSubDAOCreation(address subDAOAddress, string memory subDAOName) external {
        // Ensure that the subDAO hasn't been attested before.
        require(subDAOAttestations[subDAOAddress].timestamp == 0, "SubDAO already attested.");

        // Create a new subDAO attestation.
        SubDAOAttestation memory newAttestation = SubDAOAttestation({
            creator: msg.sender,
            subDAOName: subDAOName,
            timestamp: block.timestamp
        });

        // Store the attestation in the mapping.
        subDAOAttestations[subDAOAddress] = newAttestation;

        // Emit the event.
        emit SubDAOCreated(msg.sender, subDAOName);
    }
}