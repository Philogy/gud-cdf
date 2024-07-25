// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2 as console} from "forge-std/console2.sol";
import {FormatLib} from "./FormatLib.sol";
import {LibString} from "solady/src/utils/LibString.sol";

/// @author philogy <https://github.com/philogy>
library CDF {
    using FormatLib for *;
    using LibString for *;

    uint256 internal constant POW = 96;
    uint256 internal constant TWO = 2e18;

    error CDFArithmeticError();

    /**
     * @dev Approximation of the complementary error function "erfc" where the input is divided by
     * sqrt(2) (`1 - erf(x)`).
     * @param x Base-2 fixed point number with scale 2^POW.
     * @param y Number in WAD (fixed point number with scale 10^18).
     */
    function _innerErfc(int256 x) internal pure returns (uint256 y) {
        assembly {
            for {} 1 {} {
                // Compute absolute value of `x` (credit to
                // [Solady](https://github.com/Vectorized/solady/blob/8200a70e8dc2a77ecb074fc2e99a2a0d36547522/src/utils/FixedPointMathLib.sol#L932-L937)).
                // Exploits symmetry of `erfc` (2 - erfc(-x) = erfc(x)) and just approximates positive section,
                // flipping based on the sign at the end.
                let z := xor(sar(255, x), add(sar(255, x), x))

                // Find which of the 9 ranges `z` lies in to compute the approximation for the
                // specific range.
                if lt(z, 0x257bf44948311a21751f5911a) {
                    if lt(z, 0xc7ea6c318105e0b270a7305e) {
                        if lt(z, 0x63f53618c082f0593853982f) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffd5b9db0c63ceb616249e160d2)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xfffffffffffffffffffffffffffffffffffffffd7d33745dfe3dc692724366e3
                                )
                            num := add(sar(POW, mul(num, z)), 0x972876544bcdf0af5bde315ec)
                            let denom := add(z, 0x1a35c4a3c55bfed60e7d705dd)
                            denom := add(sar(POW, mul(denom, z)), 0x60412a301b225f7f185a16479)
                            denom := add(sar(POW, mul(denom, z)), 0xb4e4f7929d746aa17539db842)
                            y := sdiv(mul(0x109b9db6fc0bee23, num), denom)
                            break
                        }
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffa1262e64b4be6a68511604041)
                        num := add(sar(POW, mul(num, z)), 0xc04fe6d28f305c95f6e7ccd3c)
                        num :=
                            add(sar(POW, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffff7eef8c036dc49b1124094731b)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffe540db7707856a86e85033c2d)
                        denom := add(sar(POW, mul(denom, z)), 0x65ed222e7ac7c600bab4b3b6d)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffff6cb274dc1d8cb1e79970ad6db)
                        y := sdiv(mul(0xfd6d7f47435c154, num), denom)
                        break
                    }
                    if lt(z, 0x12bdfa24a4188d10ba8fac88d) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff86d590afd6f543110dcb1bdaa)
                        num := add(sar(POW, mul(num, z)), 0x14202da4573e97aa33065d5bf0)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffed4766b1477ac16ddc6d0573ed)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffa7317507e0958737926f85540)
                        denom := add(sar(POW, mul(denom, z)), 0x89df33f370acb82b21486aabf)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffe0a0a829d6d91a4490ffc279bd)
                        y := sdiv(mul(0x174407a7886b5518, num), denom)
                        break
                    }
                    if lt(z, 0x18fd4d863020bc164e14e60bc) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff755384bee352a645d6760b9c0)
                        num := add(sar(POW, mul(num, z)), 0x1a1334f87896dcbe2bb519c403)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffe4cafa887900331fee6efb8746)
                        let denom := add(z, 0x2267e2d30cf9cc880589bfab92)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffe19a3a865a2a63448264a6a9c7)
                        denom := add(sar(POW, mul(denom, z)), 0xd3fdeb3f125889c6a4fa0f0d0e)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffff9366e6f1d3aeb331, num), denom)
                        break
                    }
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff60872218dec5832b4a76fbe57)
                    num := add(sar(POW, mul(num, z)), 0x21fd4c2e435c37e60ed316ef9a)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffd853c13d7fc1db43f237f8ee62)
                    let denom := add(z, 0xffffffffffffffffffffffffffffffffffffffffd539354fd308763500c4645d)
                    denom := add(sar(POW, mul(denom, z)), 0x1a5f2d8c226c29b561a6b34df)
                    denom := add(sar(POW, mul(denom, z)), 0x932c944af1fd7e0d0e7b12f45)
                    y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffc7c3c970aee9940, num), denom)
                    break
                }
                if lt(z, 0x3e7941cf7851d637c3343f1d7) {
                    if lt(z, 0x31fa9b0c6041782c9c29cc179) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff45a7c9a03dad48bd92293bf9b)
                        num := add(sar(POW, mul(num, z)), 0x2de4ded04bdb02fc668690fe13)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffc2c6dc8c39cd00e21769ebdbfe)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffbee9b8ee73e2317967141c3c3)
                        denom := add(sar(POW, mul(denom, z)), 0x77cfb2b3c4c486c7363f6c516)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffffc99f2ac90ad234981a8b78390)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffbd516a8a7f0eec, num), denom)
                        break
                    }
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff28c3cb94a3643d102c7a28abc)
                    num := add(sar(POW, mul(num, z)), 0x3cd7d8bfaa16f8ece2ae3b5ff9)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffa3708daa096db9e7088a3dc721)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff8e5c0dbf3a0b8a4b6ecec3448)
                    denom := add(sar(POW, mul(denom, z)), 0x12095e369815d1164f46d500f5)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffff060cc84bf881bd36d2b1b1bad)
                    y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffc56ac81ffb9cd, num), denom)
                    break
                }
                if lt(z, 0x4af7e89290623442ea3eb2235) {
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff0a0a4b0e45a4e4171905f6989)
                    num := add(sar(POW, mul(num, z)), 0x4f2c5c1740c926e3a0b94f83c7)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffff7759ea168c05c4df68af2313a0)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff6117af2b629818271bde431f1)
                    denom := add(sar(POW, mul(denom, z)), 0x21a71a35cff61c5cd101a39cf2)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffd9605b79cd8e471aa9de9da17a)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffdf85535a5380, num), denom)
                    break
                }
                if lt(z, 0x63f53618c082f0593853982f2) {
                    let num := add(z, 0xffffffffffffffffffffffffffffffffffffffedb01258e79955c0b1913eab3c)
                    num := add(sar(POW, mul(num, z)), 0x6ff1ddea79844dd05f98e4e178)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffff1b84b04607e60dca6fe22a1fa3)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff2ccc7ae54c1c1bae667f32680)
                    denom := add(sar(POW, mul(denom, z)), 0x3a7aa317750233903399a50dfe)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffa9254fb937c639e28810795a01)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffd1fca5afe2, num), denom)
                    break
                }
                y := 0
                break
            }

            if slt(x, 0) { y := sub(TWO, y) }
        }
    }

    function cdf(int256 x, int256 mu, uint256 sigma) internal pure returns (uint256) {
        // cdf(x) = erfc(-x) / 2
        int256 base2X;
        assembly ("memory-safe") {
            let num := sub(mu, x)
            // Signed subtraction overflow/underflow check.
            let noError := eq(slt(num, mu), sgt(x, 0))
            let z := shl(POW, num)
            // Check shift overflow.
            noError := and(noError, eq(sar(POW, z), num))
            // Check that sigma is positive when interpreted as a two's complement number.
            noError := and(noError, sgt(sigma, 0))
            if iszero(noError) {
                mstore(0x00, 0xb8f629c0 /*CDFArithmeticError()*/ )
                revert(0x1c, 0x04)
            }
            // Complete final division.
            base2X := sdiv(z, sigma)
        }
        return _innerErfc(base2X) >> 1;
    }
}
