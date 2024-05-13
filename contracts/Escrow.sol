
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) external;
}

contract Escrow {
    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

    modifier onlyBuyer(uint256 _nftID) {
        require(msg.sender == buyer[_nftID], "Only buyer can call this method");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this method");
        _;
    }

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice;
    mapping(uint256 => uint256) public escrowAmount;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => bool) public inspectionPassed;
    mapping(uint256 => mapping(address => bool)) public approval;

    constructor(
        address _nftAddress,
        address payable _seller,
        address _inspector,
        address _lender
    ) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }

    function list(
        uint256 _nftID,
        address _buyer,
        uint256 _purchasePrice,
        uint256 _escrowAmount
    ) public payable onlySeller {
        // Transfer NFT from seller to this contract
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        escrowAmount[_nftID] = _escrowAmount;
        buyer[_nftID] = _buyer;
    }

    // Put Under Contract (only buyer - payable escrow)
    function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID) {
        require(msg.value >= escrowAmount[_nftID]);
    }

    // Update Inspection Status (only inspector)
    function updateInspectionStatus(uint256 _nftID, bool _passed)
        public
        onlyInspector
    {
        inspectionPassed[_nftID] = _passed;
    }

    // Approve Sale
    function approveSale(uint256 _nftID) public {
        approval[_nftID][msg.sender] = true;
    }

    // Finalize Sale
    // -> Require inspection status (add more items here, like appraisal)
    // -> Require sale to be authorized
    // -> Require funds to be correct amount
    // -> Transfer NFT to buyer
    // -> Transfer Funds to Seller
    function finalizeSale(uint256 _nftID) public {
        require(inspectionPassed[_nftID]);
        require(approval[_nftID][buyer[_nftID]]);
        require(approval[_nftID][seller]);
        require(approval[_nftID][lender]);
        require(address(this).balance >= purchasePrice[_nftID]);

        isListed[_nftID] = false;

        (bool success, ) = payable(seller).call{value: address(this).balance}(
            ""
        );
        require(success);

        IERC721(nftAddress).transferFrom(address(this), buyer[_nftID], _nftID);
    }

    // Cancel Sale (handle earnest deposit)
    // -> if inspection status is not approved, then refund, otherwise send to seller
    function cancelSale(uint256 _nftID) public {
        if (inspectionPassed[_nftID] == false) {
            payable(buyer[_nftID]).transfer(address(this).balance);
        } else {
            payable(seller).transfer(address(this).balance);
        }
    }

    receive() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// SPDX-License-Identifier: Unlicense
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// contract Escrow {
//     address public nftAddress;
//     address payable public seller;
//     address public inspector;
//     address public lender;

//     modifier onlyBuyer(uint256 nftID) {
//         require(msg.sender == buyer[nftID], "Only buyer can call this method");
//         _;
//     }

//     modifier onlySeller() {
//         require(msg.sender == seller, "Only seller can call this method");
//         _;
//     }

//     modifier onlyInspector() {
//         require(msg.sender == inspector, "Only inspector can call this method");
//         _;
//     }

//     mapping(uint256 => bool) public isListed;
//     mapping(uint256 => uint256) public purchasePrice;
//     mapping(uint256 => uint256) public escrowAmount;
//     mapping(uint256 => address) public buyer;
//     mapping(uint256 => bool) public inspectionPassed;
//     mapping(uint256 => mapping(address => bool)) public approval;

//     constructor(
//         address _nftAddress,
//         address payable _seller,
//         address _inspector,
//         address _lender
//     ) {
//         nftAddress = _nftAddress;
//         seller = _seller;
//         inspector = _inspector;
//         lender = _lender;
//     }

//     // List the property for sale and transfer NFT to this contract
//     function list(
//         uint256 nftID,
//         address _buyer,
//         uint256 _purchasePrice,
//         uint256 _escrowAmount
//     ) public onlySeller {
//         IERC721(nftAddress).transferFrom(msg.sender, address(this), nftID);

//         isListed[nftID] = true;
//         purchasePrice[nftID] = _purchasePrice;
//         escrowAmount[nftID] = _escrowAmount;
//         buyer[nftID] = _buyer;
//     }

//     // Buyer deposits the earnest money
//     function depositEarnest(uint256 nftID) public payable onlyBuyer(nftID) {
//         require(msg.value >= escrowAmount[nftID], "Not enough ether sent");
//         escrowAmount[nftID] = msg.value;  // Update the actual escrow amount with what was sent
//     }

//     // Inspector updates the inspection status
//     function updateInspectionStatus(uint256 nftID, bool passed) public onlyInspector {
//         inspectionPassed[nftID] = passed;
//     }

//     // Approve the sale
//     function approveSale(uint256 nftID) public {
//         approval[nftID][msg.sender] = true;
//     }

//     // Finalize the sale, transfer NFT to buyer, funds to seller
//     function finalizeSale(uint256 nftID) public {
//         require(inspectionPassed[nftID], "Inspection has not passed");
//         require(approval[nftID][buyer[nftID]], "Buyer has not approved the sale");
//         require(approval[nftID][seller], "Seller has not approved the sale");
//         require(approval[nftID][lender], "Lender has not approved the sale");
//         require(address(this).balance >= purchasePrice[nftID], "Not enough ether to finalize the sale");

//         isListed[nftID] = false;

//         (bool success, ) = seller.call{value: purchasePrice[nftID]}("");
//         require(success, "Failed to send Ether");

//         IERC721(nftAddress).transferFrom(address(this), buyer[nftID], nftID);
//     }

//     // Cancel the sale and handle the earnest deposit
//     function cancelSale(uint256 nftID) public {
//         require(isListed[nftID], "Property is not listed");

//         if (!inspectionPassed[nftID]) {
//             payable(buyer[nftID]).transfer(escrowAmount[nftID]);
//         } else {
//             (bool success, ) = seller.call{value: escrowAmount[nftID]}("");
//             require(success, "Failed to refund the buyer");
//         }

//         isListed[nftID] = false;
//     }

//     // Receive function to accept ETH
//     receive() external payable {}

//     // Get the contract's balance
//     function getBalance() public view returns (uint256) {
//         return address(this).balance;
//     }
// }
