// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner ; 
        string title ; 
        string description ; 
        uint256 target ; 
        uint256 deadline ;
        uint256 amountCollected ; 
        string image  ; 
        address[] donators ; 
        uint256[] donations ; 
    }

    mapping (uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0 ;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target , uint256 _deadline, string memory _image)  public returns(uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns] ; 
        require(campaign.deadline < block.timestamp, "The deadlien should be a date in teh future");

        campaign.owner = _owner ;
        campaign.title = _title  ;
        campaign.description = _description ; 
        campaign.target = _target ; 
        campaign.deadline = _deadline  ; 
        campaign.amountCollected = 0 ;
        campaign.image = _image ; 

        numberOfCampaigns++ ;

        return numberOfCampaigns - 1 ;

    }   

    function donateToCampaign(uint256 _id) public payable{
        // id is the id of the campaign we donate 
        uint256 amount = msg.value ; 

        Campaign storage campaign = campaigns[_id] ; 

        campaign.donators.push(msg.sender) ; 
        campaign.donations.push(amount) ; 

        // instant function, declare and call it right after declaring.
        (bool sent,) = payable(campaign.owner).call{value: amount}("") ;

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount ; 
        }
    }

    function getDonator(uint256 _id) view public returns(address[] memory, uint256[] memory) {
        // id is the id of the campaign
        return (campaigns[_id].donators,campaigns[_id].donations) ;    
    }

    function getCampaigns() public view returns(Campaign[] memory) {
        // create an array with the size of the num of struc t and return this array 
        // then loop thorught it and assign the corrsponding value for the mapping thing 
        Campaign[] memory allCampains =  new Campaign[](numberOfCampaigns);

        for (uint i = 0 ; i < numberOfCampaigns ; i++) {
            Campaign storage item = campaigns[i] ;

            allCampains[i] = item ; 
        }

        return allCampains ;
    }
}