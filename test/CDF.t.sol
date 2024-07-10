// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {CDF} from "../src/CDF.sol";
import {console2 as console} from "forge-std/console2.sol";
import {LibString} from "solady/src/utils/LibString.sol";
import {FormatLib} from "../src/FormatLib.sol";
import {Gaussian} from "solstat/Gaussian.sol";
import {PRNG} from "../src/PRNG.sol";

/// @author philogy <https://github.com/philogy>
contract CDFTest is Test {
    using FormatLib for *;
    using LibString for *;

    uint256 internal constant POW = 80;

    function setUp() public {}

    function test_gas_erf() public view {
        int256 start = -5.25e18;
        int256 end = 5.25e18;
        uint256 count = 200;
        uint256 totalGas;
        for (uint256 i = 0; i < count; i++) {
            int256 x = (end - start) * int256(i) / int256(count - 1) + start;
            uint256 before = gasleft();
            CDF.erfc(x);
            totalGas += before - gasleft();
        }
        console.log("totalGas: %s", totalGas);
    }

    function test_gas_waylon() public view {
        int256 start = -5.25e18;
        int256 end = 5.25e18;
        uint256 count = 200;
        uint256 totalGas;
        for (uint256 i = 0; i < count; i++) {
            int256 x = (end - start) * int256(i) / int256(count - 1) + start;
            uint256 before = gasleft();
            Gaussian.erfc(x);
            totalGas += before - gasleft();
        }
        console.log("totalGas: %s", totalGas);
    }

    struct ErrorTracker {
        uint256 max;
        uint256 total;
        uint256 n;
    }

    function test_avg_error() public {
        PRNG memory rng = PRNG(123);
        uint256 samples = 1000;

        ErrorTracker memory waylon;
        ErrorTracker memory philogy;

        for (uint256 i = 0; i < samples; i++) {
            int256 x = rng.randint(-7e18, 7e18);
            uint256 y = _fullCdf(x);
            _update(waylon, y, uint256(Gaussian.cdf(x)));
            uint256 myY = CDF.cdf(x, 0, 1e18);
            uint256 err = _update(philogy, y, myY);
            if (err > 0.1e18) {
                uint256 cOut = CDF.erfc(x);
                console.log("cdf(%s) = %s (%s)", x.formatDecimals(18), y.formatDecimals(18), myY.formatDecimals(18));
                console.log("  error: %s", err.formatDecimals());
                console.log("  cOut: %s", cOut);
            }
        }

        console.log("waylon:");
        _show(waylon);
        console.log("philogy:");
        _show(philogy);
    }

    function test_bad_erf() public {
        int256 x = -6.219761545359106298e18;

        uint256 approxOut = CDF.cdf(x, 0, 1e18);
        console.log("approxOut: %s", approxOut);
        uint256 realOut = _fullCdf(x);
        console.log("realOut  : %s", realOut);

        uint256 altOut = (1e18 - debug_erf(uint256(-x))) / 2;
        console.log("altOut   : %s", altOut);
    }

    function debug_erf(uint256 z) internal pure returns (uint256 y) {
        int256 num1;
        int256 num2;
        int256 num3;
        int256 denom1;
        int256 denom2;
        int256 denom3;
        z = (z << 80) / 1e18;
        assembly {
            num1 := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff2ccc79d619d0baffcea69)
            num2 := add(sar(POW, mul(num1, z)), 0x3a7aa3c8ba4898daefd6ef)
            num3 := add(sar(POW, mul(num2, z)), 0xffffffffffffffffffffffffffffffffffffffffffa9254de3a3975fc547e99b)
            denom1 := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff2ccc7ae54c1c1bae667f4)
            denom2 := add(sar(POW, mul(denom1, z)), 0x3a7aa317750233903399a5)
            denom3 := add(sar(POW, mul(denom2, z)), 0xffffffffffffffffffffffffffffffffffffffffffa9254fb937c639e288107a)
            y := sdiv(mul(0xde0b6e1aabe501e, num3), denom3)
        }
        console.log("num1: %s", _powFmt(num1));
        console.log("num2: %s", _powFmt(num2));
        console.log("num3: %s", _powFmt(num3));
        console.log("denom1: %s", _powFmt(denom1));
        console.log("denom2: %s", _powFmt(denom2));
        console.log("denom3: %s", _powFmt(denom3));
    }

    function _powFmt(int256 x) internal pure returns (string memory) {
        return ((x * 1e18) >> CDF.POW).formatDecimals(18);
    }

    function _update(ErrorTracker memory tracker, uint256 y, uint256 out) internal returns (uint256 error) {
        if (out == 0) return 0;
        uint256 relError = y * 1e18 / out;
        error = relError < 1e18 ? 1e18 - relError : relError - 1e18;
        tracker.total += error;
        tracker.max = tracker.max < error ? error : tracker.max;
        tracker.n++;
    }

    function _show(ErrorTracker memory tracker) internal pure {
        console.log("  max error: %s", tracker.max.formatDecimals(18));
        console.log("  avg error: %s", (tracker.total / tracker.n).formatDecimals(18));
    }

    function _fullCdf(int256 x) internal returns (uint256) {
        string[] memory args = new string[](3);
        args[0] = ".venv/bin/python3";
        args[1] = "script/erf.py";
        args[2] = x.formatDecimals(18);
        bytes memory ret = vm.ffi(args);
        return abi.decode(ret, (uint256));
    }
}
