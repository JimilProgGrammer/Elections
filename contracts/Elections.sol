pragma solidity ^0.4.2;

contract Elections {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    //Mapping in Solidity is similar to a HashMap in Java.
    //mapping(<key type> => <value type>)
    mapping(uint => Candidate) public candidates;

    //Store accounts that have voted
    mapping(address => bool) public voters;

    //A count of candidates created is required because the mapping in Solidity does not have a fixed size that
    //you can iterate over. Some key value that is not defined, mapping will return a default value for such keys.
    //(Empty Candidate will be default return value.) This will also help in determining how big the mapping is.
    //Determing the size also aids in iterating over the mapping.
    uint public candidatesCount;

    //An event to check if a new vote has been casted.
    event votedEvent (
        uint indexed _candidateId
    );

    constructor() public {
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }

    function addCandidate(string _name) private {
        candidatesCount ++;
        /**
         * Candidate(id, name, voteCount)
         */
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    /**
     * Vote for a candidate, update the voteCount and update that the voter has voted.
     * Also, Solidity allows to pass metadata (args other than what is defined) to the function.
     * When calling from truffle console:
     *      app.vote(1, { from: web3.eth.accounts[0] })
     *              ^ id   ^ Metadata (msg.sender)
     */
    function vote (uint _candidateId) public {
        /**
         * msg -> metadata passed to the function
         * sender -> account that sent this transaction
         */
        
        // If require evaluates to true, it will continue execution; otherwise, stop and throw an exception.
        // Leftover gas will be refunded to the user.
        require(!voters[msg.sender], "Voter has already voted!");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Please pass a valid candidateId!");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount ++;

        //Trigger the event when a new vote has been casted.
        emit votedEvent(_candidateId);
    }
}