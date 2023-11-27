# Moon Vector Contracts

## Specifications

### Raise Contract

#### Constructor

Arguments needed for constructor

- Hardcap
- Softcap
- Sale Token Address
  - ERC20 token sale - OPTIONAL
  - if zero address, then not a token sale
- Raising Token Address
  - Token to receive funds in.
  - In case of ETH, this will be ZERO address
- Start Time
  - needs to be in the future or NOW
- End Time
  - needs to be in the future after start time
  - Max Time difference is 4 weeks
- Rate (in case of token sale, How many Raising Tokens per 1 Sale Token)

#### Other Functions

- `changeEndTime`
  - callable by project owner
  - allows a maximum of 2 weeks extension or 3 changes.
  - Maximum time difference allowed is 1 month from original end time. (MAX 2 months since start time)

#### Author

@ Semi Invader
