// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
 


// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Blog {
    string public name; //name of the blog
    address public owner; //owner of the contract

    using Counters for Counters.Counter;
    Counters.Counter private _postIds; //counter for the posts

    struct Post {
        uint256 id;
        string title;
        string content;
        bool published;
    }

    mapping(uint => Post) private idToPost; //mapping of post id to post
    mapping(string => Post) private hashToPost; //mapping of hash to post on IPFS 

    event PostCreated(uint id, string title, string hash); //create a post event for The Graph
    event PostUpdated(uint id, string title, string hash, bool unpublished); //update a post event for The Graph

    constructor(string memory _name) {
        console.log("Deploying a Blog with name", _name); 
        name = _name;
        owner = msg.sender; //set the name to the owner
    }
    

    function updateName(string memory _name) public { //update the name of the post 
        name = _name;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function fetchPost(string memory hash) public view returns (Post memory) {
        return hashToPost[hash];
    }

    function createPost(string memory title, string memory hash) public onlyOwner {
        _postIds.increment(); //increment the post id
        uint postId = _postIds.current(); //get the current post id
        Post storage post = idToPost[postId]; //create a new post
        post.id = postId; //set the post id
        post.title = title; 
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post; //add the post to the mapping
        emit PostCreated(postId, title, hash); //emit the event
    }
    
    function updatePost(uint postId, string memory title, string memory hash, bool published)
    public onlyOwner {
        Post storage post = idToPost[postId]; //get the post
        post.title = title; //update the title
        post.published = published; //update the published status
        post.content = hash; //update the hash
        idToPost[postId] = post; //update the post
        hashToPost[hash] = post; //update the hash
        emit PostUpdated(post.id, title, hash, published); //emit the event
    }


    function fetchPosts() public view returns (Post[] memory) {
        uint itemCount = _postIds.current(); //get the current post id

        Post[] memory posts = new Post[](itemCount); //create an array of posts

        for (uint i = 0; i < itemCount; i++) { //loop through the posts
            uint currentId = i + 1; 
            Post storage currentItem = idToPost[currentId]; //get the current post
            posts[i] = currentItem;  //create a new array of posts
        }

        return posts; 
    }



}
