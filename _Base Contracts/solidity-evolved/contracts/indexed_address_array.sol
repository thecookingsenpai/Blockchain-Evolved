// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.15;


library IndexedArrays {

    struct Array {
        address[] addresses;
        mapping(address => uint) address_index_number;
        mapping(address => bool) address_is_here;
        uint array_head;
    }

    // NOTE correcly pushes a new element
    function push(Array storage iaa, address element) public {
        // Ensure no duplicates here
        require(!iaa.address_is_here[element], "Already present");
        // Normal push
        iaa.addresses.push(element);
        // Update indexes and presence
        iaa.address_index_number[element] = iaa.array_head;
        iaa.address_is_here[element] = true;
        // Increase array length
        iaa.array_head++;
    }

    // NOTE remove the last element 

    function pop(Array storage iaa) public {
        // Get the last index and the correspondant address
        uint last_index = iaa.addresses.length - 1;
        address last_element = iaa.addresses[last_index];
        // Delete any reference on that address and shorten the array
        iaa.address_is_here[last_element] = false;
        iaa.array_head -= 1;
        // Delete last element and reference
        delete iaa.address_index_number[last_element];
        delete iaa.addresses[last_index];

    }

    // NOTE Allows to remove a specific element in the array
    function remove(Array storage iaa, address element) public {
        require(iaa.address_is_here[element], "Address is not here");
        // Take the last element, the element index and the last index
        uint index = iaa.address_index_number[element];
        uint last_index = iaa.addresses.length - 1;
        address last_element = iaa.addresses[last_index];
        // Replace the element with the last element
        iaa.addresses[index] = last_element;
        // Cut out the last element of the array
        delete iaa.addresses[last_index];
        // Delete element record
        delete iaa.address_index_number[element];
        // Remove presence of the element
        iaa.address_is_here[element] = false;
        // Update last element index
        iaa.address_index_number[last_element] = index;
        // Shorten array head
        iaa.array_head-=1;
    }

    // NOTE Retrieve, if there, any element id
    function index_of(Array storage iaa, address element) public view returns(uint index_of_){
        require(iaa.address_is_here[element], "Address is not here");
        return(iaa.address_index_number[element]);
    }

    // NOTE Uniforms also simple index call
    function get(Array storage iaa, uint _index_) public view returns(address _result) {
        return(iaa.addresses[_index_]);
    }
}

contract TEST {
    using IndexedArrays for IndexedArrays.Array;
    IndexedArrays.Array addies;

    constructor() {
        addies.push(msg.sender);
    }

}