// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC721A/ERC721AQueryable/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Mabudachi is ERC721AQueryable, Ownable {
    using ECDSA for bytes32;

    constructor() ERC721A("MABUDACHI", "MAB") {}

    uint256 public constant MAX_MINTS_AVAILABLE = 500;
    uint256 public overallLimitPerWallet = 30;
    uint256 public whitelistLimitPerWallet = 5;
    uint256 public regularMintPrice = 5 ether;
    uint256 public whitelistMintPrice = 1 ether;

    bool public regularMintEnabled = false;
    bool public whitelistMintEnabled = false;

    ///This address Whitelists Addresses
    address private signerAddress;

    function setSignerAddress(address _newSignerAddress) external onlyOwner {
        signerAddress = _newSignerAddress;
    }

    function updateOverallLimitPerWallet(uint256 _newLimitPerWallet)
        external
        onlyOwner
    {
        overallLimitPerWallet = _newLimitPerWallet;
    }

    function updateWhitelistLimitPerWallet(uint256 _newWhitelistLimitPerWallet)
        external
        onlyOwner
    {
        whitelistLimitPerWallet = _newWhitelistLimitPerWallet;
    }

    function updateRegularMintPrice(uint256 _newRegularMintPrice)
        external
        onlyOwner
    {
        regularMintPrice = _newRegularMintPrice;
    }

    function updateWhitelistMintPrice(uint256 _newWhitelistMintPrice)
        external
        onlyOwner
    {
        whitelistMintPrice = _newWhitelistMintPrice;
    }

    function toggleRegularMintEnabled() external onlyOwner {
        regularMintEnabled = !regularMintEnabled;
    }

    function toggleWhitelistMintEnabled() external onlyOwner {
        whitelistMintEnabled = !whitelistMintEnabled;
    }

    function whitelistMint(bytes calldata signature, uint64 _quantity)
        external
        payable
    {
        require(whitelistMintEnabled, "Whitelist Mint Not Enabled");
        require(
            signerAddress ==
                keccak256(
                    abi.encodePacked(
                        "\x19Ethereum Signed Message:\n32",
                        bytes32(uint256(uint160(msg.sender)))
                    )
                ).recover(signature),
            "Incorrect Signature"
        );
        require(
            msg.value == (whitelistMintPrice * _quantity),
            "Incorrect Price"
        );
        uint64 whitelistedClaimed = _getAux(msg.sender);
        require(
            (whitelistedClaimed + _quantity) < whitelistLimitPerWallet,
            "Qty > Whitelist Limit/Addr"
        );
        _setAux(msg.sender, whitelistedClaimed + _quantity);
        mint(msg.sender, _quantity);
    }

    function regularMint(uint256 _quantity) external payable {
        require(regularMintEnabled, "Regular Mint Not Enabled");
        require(msg.value == (regularMintPrice * _quantity), "Incorrect Price");
        mint(msg.sender, _quantity);
    }

    function ownerMint(uint256 quantity) external onlyOwner {
        mint(msg.sender, quantity);
    }
    
    function mint(address mintTo, uint256 quantity) private {
        require(
            (_totalMinted() + quantity) <= MAX_MINTS_AVAILABLE,
            "Batch Size Exceeds Max Mints"
        );
        require(quantity < 31, "Batch Size Cannot Exceed 30");

        _mint(mintTo, quantity);
    }

        function testSignerRecovery(bytes calldata signature) external view returns (address) {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                bytes32(uint256(uint160(msg.sender)))
            )
        ).recover(signature);
    }
}