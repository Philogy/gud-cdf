// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2 as console} from "forge-std/console2.sol";
import {FormatLib} from "./FormatLib.sol";
import {LibString} from "solady/src/utils/LibString.sol";

/// @author philogy <https://github.com/philogy>
library CDF {
    using FormatLib for *;
    using LibString for *;

    uint256 internal constant POW = 80;
    int256 internal constant WAD = 1e18;

    /**
     * @dev Approximation of the complementary error function (`1 - erf(x)`).
     */
    function erfc(int256 x) internal pure returns (uint256 y) {
        uint256 abs;
        assembly {
            for {} 1 {} {
                // Compute absolute value of `x` (credit to
                // [Solady](https://github.com/Vectorized/solady/blob/8200a70e8dc2a77ecb074fc2e99a2a0d36547522/src/utils/FixedPointMathLib.sol#L932-L937)).
                // Exploits symmetry of `erf` across origin (-erf(x) = erf(-x) and just approximates positive section,
                // flipping based on the sign at the end.
                let z := xor(sar(255, x), add(sar(255, x), x))
                abs := z
                // Convert WAD to base-2 fixed point number.
                z := div(shl(POW, z), WAD)

                // Find which of the 10 ranges `x` lies in to compute the specific approximation.
                if lt(z, 0x3e7941cf7851d637c3343) {
                    if lt(z, 0x257bf44948311a21751f5) {
                        if lt(z, 0x12bdfa24a4188d10ba8fa) {
                            if lt(z, 0x63f53618c082f0593853) {
                                let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffd5b9db0c63ceb616249e2)
                                num :=
                                    add(
                                        sar(POW, mul(num, z)),
                                        0xfffffffffffffffffffffffffffffffffffffffffffd7d33745dfe3dc6927244
                                    )
                                num := add(sar(POW, mul(num, z)), 0x972876544bcdf0af5bde3)
                                let denom := add(z, 0x1a35c4a3c55bfed60e7d7)
                                denom := add(sar(POW, mul(denom, z)), 0x60412a301b225f7f185a1)
                                denom := add(sar(POW, mul(denom, z)), 0xb4e4f7929d746aa17539d)
                                y := sdiv(mul(0x109b9db6fc0bee23, num), denom)
                                break
                            }
                            if lt(z, 0xc7ea6c318105e0b270a7) {
                                let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffa1262e64b4be6a6851161)
                                num := add(sar(POW, mul(num, z)), 0xc04fe6d28f305c95f6e7c)
                                num :=
                                    add(
                                        sar(POW, mul(num, z)),
                                        0xfffffffffffffffffffffffffffffffffffffffffff7eef8c036dc49b1124095
                                    )
                                let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffe540db7707856a86e8504)
                                denom := add(sar(POW, mul(denom, z)), 0x65ed222e7ac7c600bab4b)
                                denom :=
                                    add(
                                        sar(POW, mul(denom, z)),
                                        0xfffffffffffffffffffffffffffffffffffffffffff6cb274dc1d8cb1e79970b
                                    )
                                y := sdiv(mul(0xfd6d7f47435c154, num), denom)
                                break
                            }
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff86d590afd6f543110dcb2)
                            num := add(sar(POW, mul(num, z)), 0x14202da4573e97aa33065d)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffed4766b1477ac16ddc6d06
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffa7317507e0958737926f9)
                            denom := add(sar(POW, mul(denom, z)), 0x89df33f370acb82b21486)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffe0a0a829d6d91a4490ffc3
                                )
                            y := sdiv(mul(0x174407a7886b5518, num), denom)
                            break
                        }
                        if lt(z, 0x18fd4d863020bc164e14e) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff755384bee352a645d6761)
                            num := add(sar(POW, mul(num, z)), 0x1a1334f87896dcbe2bb519)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffe4cafa887900331fee6efc
                                )
                            let denom := add(z, 0x2267e2d30cf9cc880589bf)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffe19a3a865a2a63448264a7
                                )
                            denom := add(sar(POW, mul(denom, z)), 0xd3fdeb3f125889c6a4fa0f)
                            y :=
                                sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffff9366e6f1d3aeb331, num), denom)
                            break
                        }
                        if lt(z, 0x1f3ca0e7bc28eb1be19a1) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff676806c1f3fd3ad38f193)
                            num := add(sar(POW, mul(num, z)), 0x1f434fcbba4e31f45a7727)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffdcc692754a0669b77a5833
                                )
                            let denom := add(z, 0x179b255378d16f9cad611)
                            denom := add(sar(POW, mul(denom, z)), 0x389dd3b37fcea39300cb)
                            denom := add(sar(POW, mul(denom, z)), 0x1115162e8ab7cb12a003b0)
                            y :=
                                sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffff90792b6e24bf48c, num), denom)
                            break
                        }
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff5a359e0326e72e8e56a36)
                        num := add(sar(POW, mul(num, z)), 0x24a161625625ae7670d07e)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffffd3ce1e51c60f3f7ee59e2a)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffe837e1091a194ecdb4017)
                        denom := add(sar(POW, mul(denom, z)), 0x30b435be1647b9a61572e)
                        denom := add(sar(POW, mul(denom, z)), 0x44109a1f9fea9af62234f)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffe36aa51e50e0705, num), denom)
                        break
                    }
                    if lt(z, 0x31fa9b0c6041782c9c29c) {
                        if lt(z, 0x2bbb47aad439492708a49) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff4cbafe2b5100d36a11278)
                            num := add(sar(POW, mul(num, z)), 0x2a96b9c7b77ea49ac36532)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffc90dbfd07ab80201f6a4ef
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffca4ecfe7797f20b0b3deb)
                            denom := add(sar(POW, mul(denom, z)), 0x5f3b3fd91dc2c6a75e0d6)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xfffffffffffffffffffffffffffffffffffffffffffe99bbf9a5ff25c9ab1547
                                )
                            y :=
                                sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffff8344319be367f5, num), denom)
                            break
                        }
                        if lt(z, 0x2edaf15b9a3d60a9d2672) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff424fbff97d0a26f0d554f)
                            num := add(sar(POW, mul(num, z)), 0x2f881288a95a8c5275c7bb)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffbf86a10efb68ac6e149d44
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffb62fc6d4b57d521dff371)
                            denom := add(sar(POW, mul(denom, z)), 0x8fbddb10a43dd10c9c271)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xfffffffffffffffffffffffffffffffffffffffffffae8a83b9bbca9444a7a86
                                )
                            y :=
                                sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffd36b4134ccf80f, num), denom)
                            break
                        }
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff3b2a48953c2f297d49c7c)
                        num := add(sar(POW, mul(num, z)), 0x331637dca399dc652a3708)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffffb85b79a4009cacfa9022c0)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffffa9a4b5524430951d76849)
                        denom := add(sar(POW, mul(denom, z)), 0xb63c9e3d3c16d80e91832)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffffffff8363311a0fa1e51d06ea3)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffea122837b875b3, num), denom)
                        break
                    }
                    if lt(z, 0x3839ee6dec49a7322faf0) {
                        if lt(z, 0x351a44bd26458faf65ec6) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff33e313284d4da0d796076)
                            num := add(sar(POW, mul(num, z)), 0x36d8fe4e89ea83bfd96ea2)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffb07e83b44dd10bbb3fc503
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff9d67819f6fb93ddec0c1a)
                            denom := add(sar(POW, mul(denom, z)), 0xe253973dea93a638f28ac)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xfffffffffffffffffffffffffffffffffffffffffff5105d753ef7448a0c671b
                                )
                            y :=
                                sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffff57f69ca4fa400, num), denom)
                            break
                        }
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff2c7bafb6ea7199b1f760a)
                        num := add(sar(POW, mul(num, z)), 0x3ad170881be20460f98cdd)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffffa7e4244490b7b5ae7bd55d)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff9167ee7ae633ac391a400)
                        denom := add(sar(POW, mul(denom, z)), 0x113e6df490bf3ddf37aafc)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xfffffffffffffffffffffffffffffffffffffffffff154495e730264eaaa2f74)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffb1c2e6bf8086c, num), denom)
                        break
                    }
                    if lt(z, 0x3b59981eb24dbeb4f971a) {
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff24f5e1066d1528e9845bb)
                        num := add(sar(POW, mul(num, z)), 0x3f0063f981ca4350fad80b)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff9e80d99a5797e0164e8846)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff859cb11cf88286abe4d95)
                        denom := add(sar(POW, mul(denom, z)), 0x14ac8d1cd2c72f8e7ea6f6)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffece6d13e8f23e7bfeac37b)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffdc9fa6f4ad372, num), denom)
                        break
                    }
                    let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff1d53796d18d110274752d)
                    num := add(sar(POW, mul(num, z)), 0x436687f3620b7734aa4d48)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff94492b23fab70b03c53132)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff79ffc5d265bd1efc00857)
                    denom := add(sar(POW, mul(denom, z)), 0x186c61b567d4ac81d5f776)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffe7b216bd826e25d9909c02)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffff07ae76a73145, num), denom)
                    break
                }
                if lt(z, 0x51373bf41c6a63487dc3e) {
                    if lt(z, 0x47d83ee1ca5e1cc0207c1) {
                        if lt(z, 0x4198eb803e55edba8cf6d) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff15964895f45b30f078012)
                            num := add(sar(POW, mul(num, z)), 0x48046e4c7935e08e674bbf)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffff8931a338e126208d60ba01
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff6e8cb9c8818a9fe4009f8)
                            denom := add(sar(POW, mul(denom, z)), 0x1c7ac58208ad48f281e81d)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffe1a3d647b88c0f6c344bbc
                                )
                            y :=
                                sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffff9662034943fa, num), denom)
                            break
                        }
                        if lt(z, 0x44b89531045a053d56b97) {
                            let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff0dc011a262424079db4f3)
                            num := add(sar(POW, mul(num, z)), 0x4cda90e1755c8246407e8f)
                            num :=
                                add(
                                    sar(POW, mul(num, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffff7d2ecd4deeea7673838e01
                                )
                            let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff633fe316b178985af495e)
                            denom := add(sar(POW, mul(denom, z)), 0x20d4d517695f5068d2dd37)
                            denom :=
                                add(
                                    sar(POW, mul(denom, z)),
                                    0xffffffffffffffffffffffffffffffffffffffffffdaac3ec732f932b8aa8873
                                )
                            y :=
                                sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffd47a42c6ea20, num), denom)
                            break
                        }
                        let num := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff05d285962b46905d42891)
                        num := add(sar(POW, mul(num, z)), 0x51e9558687ad50971e4252)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff703535ea118e8a0851c5fc)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff58160898ccf7f8a58c9ef)
                        denom := add(sar(POW, mul(denom, z)), 0x2578040aa3021a7fc2dde1)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffd2bd257114ee08f63fbcaa)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffeea281ebce83, num), denom)
                        break
                    }
                    if lt(z, 0x4af7e89290623442ea3eb) {
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffefdcf402299acd63c01a69)
                        num := add(sar(POW, mul(num, z)), 0x5731112597326c1a1316ee)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff62396b196ce14457e5d9e3)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff4d0c3ccfba057b5062c98)
                        denom := add(sar(POW, mul(denom, z)), 0x2a621fd51799b84312d1d7)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffc9c979f6a91fd8f1f1c5ca)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffff94b8732807e, num), denom)
                        break
                    }
                    if lt(z, 0x4e17924356664bc5b4014) {
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffef5b7c5e3dc64ce40c0fea)
                        num := add(sar(POW, mul(num, z)), 0x5cb20a5b0e53079fcf6e4e)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff532ffcdab5ae5ac3006c22)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff421fcef59f5cbd7a9dabe)
                        denom := add(sar(POW, mul(denom, z)), 0x2f914a1bcee170734fe4b4)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffbfc4e768bc5b31df175995)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffd7ef44903db, num), denom)
                        break
                    }
                    let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffeed8d83962a7f5773ed901)
                    num := add(sar(POW, mul(num, z)), 0x626c7bb45cbaeb7af82512)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff430d7d5c9e298f378e87c6)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff374e44f8d86806590bc04)
                    denom := add(sar(POW, mul(denom, z)), 0x3503ef551055501f6ff1a6)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffb4a393dad1081ebafe9560)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffff188919aeb3, num), denom)
                    break
                }
                if lt(z, 0x5a9639066e76a9d0db0bc) {
                    if lt(z, 0x5456e5a4e26e7acb47868) {
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffee551cdfafb22043f682e8)
                        num := add(sar(POW, mul(num, z)), 0x686095a00bbb92844a5b95)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff31c68108660517c337f6f5)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff2c95587ff8d00c604ed29)
                        denom := add(sar(POW, mul(denom, z)), 0x3ab8bc7e5e34967408dbd4)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffffa859f5055a8e14924724e0)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffaf3ae50ac1, num), denom)
                        break
                    }
                    if lt(z, 0x57768f55a872924e11492) {
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffedd05e23e26144cc76d6f5)
                        num := add(sar(POW, mul(num, z)), 0x6e8e801854cad10821b0b2)
                        num :=
                            add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff1f4f9e64bc923d307bb865)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff21f2f4931390b436cc93e)
                        denom := add(sar(POW, mul(denom, z)), 0x40ae953d05eb9627f35b06)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffff9adcb32a8620a7f8ddc0e8)
                        y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffe4c56419a8, num), denom)
                        break
                    }
                    let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffed4aae6b6f7f73473ab473)
                    num := add(sar(POW, mul(num, z)), 0x74f65c0f2faf64d85a35a2)
                    num :=
                        add(sar(POW, mul(num, z)), 0xffffffffffffffffffffffffffffffffffffffffff0b9d6ddee0fc1851921b88)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff17653316df4ff25d4011f)
                    denom := add(sar(POW, mul(denom, z)), 0x46e48b01b1a3eb2de51d46)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffff8c2095a1cbd0bb38898586)
                    y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffff72281d9fa, num), denom)
                    break
                }
                if lt(z, 0x60d58c67fa7ed8d66e90f) {
                    if lt(z, 0x5db5e2b7347ac153a4ce5) {
                        let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffecc41ebe8f4bafef2502dd)
                        num := add(sar(POW, mul(num, z)), 0x7b9844a27c1fcd8108d606)
                        num :=
                            add(sar(POW, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffffffef6a489862734b03b188c1e)
                        let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff0cea59ef01b292acd067c)
                        denom := add(sar(POW, mul(denom, z)), 0x4d59d55f451b5521c94e2e)
                        denom :=
                            add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffff7c1a75e84f843ac638ce23)
                        y := sdiv(mul(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffd36969e24, num), denom)
                        break
                    }
                    let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffec3cbedadcb487053185ef)
                    num := add(sar(POW, mul(num, z)), 0x8274501ee9a0971236ca2a)
                    num :=
                        add(sar(POW, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffffffee0598cc2f8f62d5a659034)
                    let denom := add(z, 0xfffffffffffffffffffffffffffffffffffffffffff0280d7db34f844aa58943)
                    denom := add(sar(POW, mul(denom, z)), 0x540dcb90d119f016c5f281)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffff6abf3716f8f22e18bc4973)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff27882153, num), denom)
                    break
                }
                if lt(z, 0x63f53618c082f05938539) {
                    let num := add(z, 0xffffffffffffffffffffffffffffffffffffffffffebb49d476c8b544ab85b39)
                    num := add(sar(POW, mul(num, z)), 0x898a90d81c92c261098946)
                    num :=
                        add(sar(POW, mul(num, z)), 0xfffffffffffffffffffffffffffffffffffffffffec8b1140f70f4d7ba00d5d3)
                    let denom := add(z, 0xffffffffffffffffffffffffffffffffffffffffffef82741331e241e6ea9698)
                    denom := add(sar(POW, mul(denom, z)), 0x5affdf12a5dff4ab5149f5)
                    denom :=
                        add(sar(POW, mul(denom, z)), 0xffffffffffffffffffffffffffffffffffffffffff5803c04f22bcd2769ed77b)
                    y := sdiv(mul(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffc09d3eb8, num), denom)
                    break
                }
                y := 0
                break
            }

            if slt(x, 0) { y := sub(2000000000000000000, y) }
        }
    }

    function cdf(int256 x, int256 gamma, uint256 sigma) internal pure returns (uint256) {
        return erfc((gamma - x) * WAD / int256(sigma)) >> 1;
    }
}
