// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

contract DistributedDictionaryMinimal {

    constructor(){
        initWithWords();
    }

    struct Post {
        uint id;
        string wordMeaning;
        int votes;
        address author;
    }

    struct Word{
        Post[] posts;
    }

    mapping (string => Word) private wordsMap;
    string[] private wordsArray; // mapping does not preserve original words, so we also have words as array.
    

    // ---------- ---------- state changing functions ---------- ----------
    function addPost(string memory newWord, string memory wordMeaning) public{
        // adds Post to a word, crates word if not exists
        
        // add word if not exists
        if(!isWordExists(newWord)){
            wordsArray.push(newWord);
        }

        // create post
        Post memory newPost = Post(
            {
                wordMeaning: wordMeaning,
                author: msg.sender,
                votes: 0,
                id: wordsMap[newWord].posts.length
            }
        );

        // add new post to word map
        wordsMap[newWord].posts.push(newPost);
    }


    function votePost(string memory word, uint votePostId, bool voteType) public{
        // up or down votes a post
        for (uint i = 0; i < wordsMap[word].posts.length; i++) {
            if(wordsMap[word].posts[i].id == votePostId){
                if(voteType){
                    wordsMap[word].posts[i].votes += 1;
                }
                else{
                    wordsMap[word].posts[i].votes -= 1;
                }
                break;
            }
        }
    }
    // ---------- ---------- ---------- ---------- ----------


    // ---------- ---------- post getters ---------- ----------
    function getPostsByWord(string memory word) view public returns (Post[] memory){
        // returnes posts for a word
        return wordsMap[word].posts;
    }
    // ---------- ---------- ---------- ---------- ----------
    

    // ---------- ---------- word getters ---------- ----------
    function getWordsBetween(uint start, uint end) view public returns (string[] memory){
        // returnes words in between a range
        string[] memory temp = new string[](end - start);
        
        uint j = 0;
        for (uint i = start; i < end; i++) {
            temp[j] = wordsArray[i];
            j++;
        }
    
        return temp;
    } 

    function getAllWords() view public returns (string[] memory){
        // returnes all saved words
        return wordsArray;
    }

    function getWordCount() view public returns (uint){
        // returnes word array length
        return wordsArray.length;
    }

    function isWordExists(string memory word) view public returns (bool){
        // returnes true if a word exists
        if(wordsMap[word].posts.length > 0){
            return true;
        }
        else{
            return false;
        }
    }
    // ---------- ---------- ---------- ---------- ----------  


    // ---------- ---------- other ---------- ----------
    function initWithWords() private {
        // for initialising contract with words
        addPost("Distributed Dictionary", "A user-created dictionary that runs entirely on the blockchain without the need for a centralized backend.");
    }
    // ---------- ---------- ---------- ---------- ----------  

}

