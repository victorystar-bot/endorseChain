# Decentralized Professional Endorsement System

A blockchain-based solution for creating professional profiles and receiving verified skill endorsements on the Stacks blockchain.

## Overview

This project provides a decentralized alternative to professional networking platforms like LinkedIn, where skill endorsements and professional reputation are stored on-chain for transparency, immutability, and user control.

The system is divided into two smart contracts:
1. **Profile Manager Contract**: Handles the creation and management of professional profiles and skills
2. **Endorsement Contract**: Manages the endorsement system and skill validation

## Key Features

- **Decentralized Professional Profiles**: Users can create and manage their professional profiles with full ownership
- **Skill Management**: Add, update, and showcase skills on your profile
- **Verifiable Endorsements**: Receive endorsements from other professionals that are verifiable on-chain
- **Rating System**: Skills include a 1-5 rating system to quantify expertise level
- **Transparent Reputation**: All endorsements are publicly visible and cannot be altered retroactively

## Technical Architecture

### Profile Manager Contract
- Manages user profiles with name, bio, and contact information
- Handles skill creation and updates
- Maps profiles to their respective owners
- Provides read functions to retrieve profile and skill information


## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed for local development
- Basic understanding of Clarity smart contracts and the Stacks blockchain

### Deployment

1. Deploy the Profile Manager contract first
2. Deploy the Endorsement contract with the Profile Manager contract's principal
3. Set up the Profile Manager contract principal in the Endorsement contract using the `set-profile-contract` function

### Basic Usage

#### Create a Profile
```clarity
(contract-call? .profile-manager create-profile "John Doe" "Blockchain Developer with 5+ years experience" "john@example.com")
```

#### Add a Skill
```clarity
(contract-call? .profile-manager add-skill "Smart Contract Development" "Proficient in Clarity and Solidity")
```

#### Endorse a Skill
```clarity
(contract-call? .endorsement endorse-skill 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM u1 u5 "Excellent smart contract developer. Highly recommended!")
```

## Security Considerations

- Both contracts implement proper authorization checks
- Endorsements cannot be created for non-existent profiles or skills
- Self-endorsements are prohibited
- Profiles and skills are properly validated for input length and content

## Future Enhancements

- Implement token rewards for active endorsers
- Add verification badges for highly endorsed professionals
- Create skill categories and specializations
- Implement dispute resolution for questionable endorsements
- Add profile verification through trusted third parties

## License

This project is licensed under the MIT License.