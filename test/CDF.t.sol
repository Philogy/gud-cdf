// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {CDF} from "../src/CDF.sol";
import {console2 as console} from "forge-std/console2.sol";
import {LibString} from "solady/src/utils/LibString.sol";
import {FormatLib} from "../src/FormatLib.sol";

/// @author philogy <https://github.com/philogy>
contract CDFTest is Test {
    using FormatLib for *;
    using LibString for *;

    function setUp() public {}

    function test_gas_erf() public pure {
        int256 start = -7.0e18;
        int256 end = 7.0e18;
        uint256 count = 200;
        for (uint256 i = 0; i < count; i++) {
            int256 x = (end - start) * int256(i) / int256(count - 1) + start;
            CDF.erf(x);
        }
    }
}
