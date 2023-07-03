// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.6;

contract Chat {
    struct Message {
        address sender;
        string content;
        uint timestamp;
    }

    Message[] public messages;

    function sendMessage(address _sender, string memory _content) public {
        messages.push(Message(_sender, _content, block.timestamp));
    }

    function getMessageCount() public view returns (uint) {
        return messages.length;
    }

    function getMessages(address _address) public view returns(Message[] memory) {
        uint count = 0;

        // We first need to know how many messages are from the provided address.
        for(uint i = 0; i < messages.length; i++) {
            if (messages[i].sender == _address) {
                count++;
            }
        }

        // Initialize a new array with the correct length.
        Message[] memory senderMessages = new Message[](count);

        // Add the messages of the sender to the new array.
        uint index = 0;
        for(uint i = 0; i < messages.length; i++) {
            if (messages[i].sender == _address) {
                senderMessages[index] = messages[i];
                index++;
            }
        }

        return senderMessages;
    }

    function getAllMessages() public view returns (Message[] memory) {
        return messages;
    }
}