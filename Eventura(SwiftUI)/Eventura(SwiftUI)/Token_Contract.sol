// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
  // code here

contract EventToken is ERC721 {
    struct Event {
        uint256 id;
        string time;
        string location;
        string date;
        string image;
    }

    Event[] public events;
    mapping(uint256 => address) public eventToOwner;

    constructor() ERC721("Event Token", "EVENT") {}

    function mint(string memory _time, string memory _location, string memory _date, string memory _image, address recipient) public {
        uint256 newEventId = events.length;
        events.push(Event(newEventId, _time, _location, _date, _image));
        eventToOwner[newEventId] = recipient;
        _safeMint(recipient, newEventId);
    }
}
