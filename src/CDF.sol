// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2 as console} from "forge-std/console2.sol";
import {FormatLib} from "./FormatLib.sol";

/// @author philogy <https://github.com/philogy>
library CDF {
    using FormatLib for *;

    uint256 internal constant POW = 96;
    int256 internal constant WAD = 1e18;

    /**
     * @dev Approximation of the error function to 8 digits accuracy.
     */
    function erf(int256 x) internal pure returns (int256 y) {
        assembly {
            for {} 1 {} {
                // Compute absolute value of `x` (credit to
                // [Solady](https://github.com/Vectorized/solady/blob/8200a70e8dc2a77ecb074fc2e99a2a0d36547522/src/utils/FixedPointMathLib.sol#L932-L937)).
                // Exploits symmetry of `erf` across origin (-erf(x) = erf(-x) and just approximates positive section,
                // flipping based on the sign at the end.
                let z := xor(sar(255, x), add(sar(255, x), x))
                // Convert WAD to base-2 fixed point number.
                z := div(shl(POW, z), WAD)

                // Find which of the 10 ranges `x` lies in to compute the specific approximation.
                if lt(z, 0x257bf44948311a21751f5911a) {
                    if lt(z, 0xc7ea6c318105e0b270a7305e) {
                        if lt(z, 0x63f53618c082f0593853982f) {
                            let num := add(z, 0xffffffffffffffffffffffffffffffffffffffe799a4edba474fade4d0edc6f1)
                            num :=
                                add(
                                    sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffd2250fb8edc41e86a20be1f587
                                )
                            num :=
                                add(
                                    sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffffffffd884d833994fd60e8c
                                )
                            let denom := add(z, 0x1a35c4a3c55bfed60e7d705dd)
                            denom := add(sar(96, mul(denom, z)), 0x60412a301b225f7f185a16479)
                            denom := add(sar(96, mul(denom, z)), 0xb4e4f7929d746aa17539db842)
                            y :=
                                sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffd4518fcab5811dd, num), denom)
                            break
                        }
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffdbf4ad32beceb0a894e96cac8a)
                        num := add(sar(96, mul(num, z)), 0x33fd15a515e1367b7a5e1b5847)
                        num :=
                            add(sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffffab50184faeb2f3bbf7e4e9)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffe540db7707856a86e85033c2d)
                        denom := add(sar(96, mul(denom, z)), 0x65ed222e7ac7c600bab4b3b6d)
                        denom :=
                            add(sar(96, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffff6cb274dc1d8cb1e79970ad6db)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffe09debf332e3eac, num), denom)
                        break
                    }
                    if lt(z, 0x12bdfa24a4188d10ba8fac88d) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff56ffdcc19d8a4d979bba71004)
                        num := add(sar(96, mul(num, z)), 0x2523743cccda7350d430f08ec7)
                        num :=
                            add(sar(96, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffffffb171de16ee752737a60db95)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffa7317507e0958737926f85540)
                        denom := add(sar(96, mul(denom, z)), 0x89df33f370acb82b21486aabf)
                        denom :=
                            add(sar(96, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffe0a0a829d6d91a4490ffc279bd)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffff69caf0c1ef8aae8, num), denom)
                        break
                    }
                    if lt(z, 0x18fd4d863020bc164e14e60bc) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffc36a7f797c9b815a5c24603c7)
                        num := add(sar(96, mul(num, z)), 0x13ad14a0a070f0d2a982abd34d)
                        num :=
                            add(sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffe58922ddb7a309a6f1987203)
                        let denom := add(z, 0x2267e2d30cf9cc880589bfab92)
                        denom :=
                            add(sar(96, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffe19a3a865a2a63448264a6a9c7)
                        denom := add(sar(96, mul(denom, z)), 0xd3fdeb3f125889c6a4fa0f0d0e)
                        y := sdiv(mul(0x7a79cfc1d3b54ccf, num), denom)
                        break
                    }
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffdda3ef14e478c910b98a14ec9)
                    num := add(sar(96, mul(num, z)), 0x82f0d52bac19c14e111146a9b)
                    num := add(sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffff5289b853d22690c4da1ef439)
                    let denom := add(z, 0xffffffffffffffffffffffffffffffffffffffffd539354fd308763500c4645d)
                    denom := add(sar(96, mul(denom, z)), 0x1a5f2d8c226c29b561a6b34df)
                    denom := add(sar(96, mul(denom, z)), 0x932c944af1fd7e0d0e7b12f45)
                    y := sdiv(mul(0x11647a1c9c7566c0, num), denom)
                    break
                }
                if lt(z, 0x3e7941cf7851d637c3343f1d7) {
                    if lt(z, 0x31fa9b0c6041782c9c29cc179) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffbcadd22eb82be4ef99d5ee2f4)
                        num := add(sar(96, mul(num, z)), 0x8321e789a45ad1fa1ca9392c1)
                        num :=
                            add(sar(96, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffffb89392062a2d9a13991e501c6)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffbee9b8ee73e2317967141c3c3)
                        denom := add(sar(96, mul(denom, z)), 0x77cfb2b3c4c486c7363f6c516)
                        denom :=
                            add(sar(96, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffffc99f2ac90ad234981a8b78390)
                        y := sdiv(mul(0xe2365491ce4f114, num), denom)
                        break
                    }
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff8e4146f3d57da26b216198ac0)
                    num := add(sar(96, mul(num, z)), 0x1214a6744c4d8e76a525a3d233)
                    num := add(sar(96, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffff04c85550cd1b07eb79a9f2427)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff8e5c0dbf3a0b8a4b6ecec3448)
                    denom := add(sar(96, mul(denom, z)), 0x12095e369815d1164f46d500f5)
                    denom :=
                        add(sar(96, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffff060cc84bf881bd36d2b1b1bad)
                    y := sdiv(mul(0xde4600725644633, num), denom)
                    break
                }
                if lt(z, 0x4af7e89290623442ea3eb2235) {
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff6116e3711ff8c2dda2b380615)
                    num := add(sar(96, mul(num, z)), 0x21a784bdce055c3e3f780ea7b0)
                    num := add(sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffd95f76118c896e9a821411e72d)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff6117af2b629818271bde431f1)
                    denom := add(sar(96, mul(denom, z)), 0x21a71a35cff61c5cd101a39cf2)
                    denom :=
                        add(sar(96, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffd9605b79cd8e471aa9de9da17a)
                    y := sdiv(mul(0xde0d72e5409ac80, num), denom)
                    break
                }
                if lt(z, 0x63f53618c082f0593853982f2) {
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffff2ccc79d619d0baffcea685f6b)
                    num := add(sar(96, mul(num, z)), 0x3a7aa3c8ba4898daefd6efeb42)
                    num := add(sar(96, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffa9254de3a3975fc547e99a7bf5)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffff2ccc7ae54c1c1bae667f32680)
                    denom := add(sar(96, mul(denom, z)), 0x3a7aa317750233903399a50dfe)
                    denom :=
                        add(sar(96, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffa9254fb937c639e28810795a01)
                    y := sdiv(mul(0xde0b6e1aabe501e, num), denom)
                    break
                }
                y := 1000000000000000000
                break
            }

            if slt(x, 0) { y := sub(0, y) }
        }
    }

    function cdf(int256 x, int256 gamma, uint256 sigma) internal pure returns (int256) {
        return (WAD + erf((x - gamma) * WAD / int256(sigma))) >> 1;
    }
}
