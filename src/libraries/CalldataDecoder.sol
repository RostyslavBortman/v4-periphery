// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {PositionConfig} from "./PositionConfig.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IV4Router} from "../interfaces/IV4Router.sol";

/// @title Library for abi decoding in calldata
library CalldataDecoder {
    using CalldataDecoder for bytes;

    error SliceOutOfBounds();

    /// @notice equivalent to SliceOutOfBounds.selector
    bytes4 constant SLICE_ERROR_SELECTOR = 0x3b99b53d;

    /// @notice mask used for offsets and lengths to ensure no overflow
    /// @dev no sane abi encoding will pass in an offset or length greater than type(uint32).max
    uint256 constant OFFSET_OR_LENGTH_MASK = 0xffffffff;

    /// @dev equivalent to: abi.decode(params, (bytes, bytes[])) in calldata
    function decodeActionsRouterParams(bytes calldata _bytes)
        internal
        pure
        returns (bytes calldata actions, bytes[] calldata params)
    {
        actions = _bytes.toBytes(0);
        params = _bytes.toBytesArray(1);
    }

    /// @dev equivalent to: abi.decode(params, (uint256, PositionConfig, uint256, uint128, uint128, bytes)) in calldata
    function decodeModifyLiquidityParams(bytes calldata params)
        internal
        pure
        returns (
            uint256 tokenId,
            PositionConfig calldata config,
            uint256 liquidity,
            uint128 amount0,
            uint128 amount1,
            bytes calldata hookData
        )
    {
        assembly ("memory-safe") {
            tokenId := calldataload(params.offset)
            config := add(params.offset, 0x20)
            liquidity := calldataload(add(params.offset, 0x100))
            amount0 := calldataload(add(params.offset, 0x120))
            amount1 := calldataload(add(params.offset, 0x140))
        }
        hookData = params.toBytes(11);
    }

    /// @dev equivalent to: abi.decode(params, (PositionConfig, uint256, uint128, uint128, address, bytes)) in calldata
    function decodeMintParams(bytes calldata params)
        internal
        pure
        returns (
            PositionConfig calldata config,
            uint256 liquidity,
            uint128 amount0Max,
            uint128 amount1Max,
            address owner,
            bytes calldata hookData
        )
    {
        assembly ("memory-safe") {
            config := params.offset
            liquidity := calldataload(add(params.offset, 0xe0))
            amount0Max := calldataload(add(params.offset, 0x100))
            amount1Max := calldataload(add(params.offset, 0x120))
            owner := calldataload(add(params.offset, 0x140))
        }
        hookData = params.toBytes(11);
    }

    /// @dev equivalent to: abi.decode(params, (uint256, PositionConfig, uint128, uint128, bytes)) in calldata
    function decodeBurnParams(bytes calldata params)
        internal
        pure
        returns (
            uint256 tokenId,
            PositionConfig calldata config,
            uint128 amount0Min,
            uint128 amount1Min,
            bytes calldata hookData
        )
    {
        assembly ("memory-safe") {
            tokenId := calldataload(params.offset)
            config := add(params.offset, 0x20)
            amount0Min := calldataload(add(params.offset, 0x100))
            amount1Min := calldataload(add(params.offset, 0x120))
        }
        hookData = params.toBytes(10);
    }

    /// @dev equivalent to: abi.decode(params, (IV4Router.ExactInputParams))
    function decodeSwapExactInParams(bytes calldata params)
        internal
        pure
        returns (IV4Router.ExactInputParams calldata swapParams)
    {
        // ExactInputParams is a variable length struct so we just have to look up its location
        assembly ("memory-safe") {
            swapParams := add(params.offset, calldataload(params.offset))
        }
    }

    /// @dev equivalent to: abi.decode(params, (IV4Router.ExactInputSingleParams))
    function decodeSwapExactInSingleParams(bytes calldata params)
        internal
        pure
        returns (IV4Router.ExactInputSingleParams calldata swapParams)
    {
        // ExactInputSingleParams is a variable length struct so we just have to look up its location
        assembly ("memory-safe") {
            swapParams := add(params.offset, calldataload(params.offset))
        }
    }

    /// @dev equivalent to: abi.decode(params, (IV4Router.ExactOutputParams))
    function decodeSwapExactOutParams(bytes calldata params)
        internal
        pure
        returns (IV4Router.ExactOutputParams calldata swapParams)
    {
        // ExactOutputParams is a variable length struct so we just have to look up its location
        assembly ("memory-safe") {
            swapParams := add(params.offset, calldataload(params.offset))
        }
    }

    /// @dev equivalent to: abi.decode(params, (IV4Router.ExactOutputSingleParams))
    function decodeSwapExactOutSingleParams(bytes calldata params)
        internal
        pure
        returns (IV4Router.ExactOutputSingleParams calldata swapParams)
    {
        // ExactOutputSingleParams is a variable length struct so we just have to look up its location
        assembly ("memory-safe") {
            swapParams := add(params.offset, calldataload(params.offset))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency)) in calldata
    function decodeCurrency(bytes calldata params) internal pure returns (Currency currency) {
        assembly ("memory-safe") {
            currency := calldataload(params.offset)
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, Currency)) in calldata
    function decodeCurrencyPair(bytes calldata params) internal pure returns (Currency currency0, Currency currency1) {
        assembly ("memory-safe") {
            currency0 := calldataload(params.offset)
            currency1 := calldataload(add(params.offset, 0x20))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, Currency, address)) in calldata
    function decodeCurrencyPairAndAddress(bytes calldata params)
        internal
        pure
        returns (Currency currency0, Currency currency1, address _address)
    {
        assembly ("memory-safe") {
            currency0 := calldataload(params.offset)
            currency1 := calldataload(add(params.offset, 0x20))
            _address := calldataload(add(params.offset, 0x40))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, address)) in calldata
    function decodeCurrencyAndAddress(bytes calldata params)
        internal
        pure
        returns (Currency currency, address _address)
    {
        assembly ("memory-safe") {
            currency := calldataload(params.offset)
            _address := calldataload(add(params.offset, 0x20))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, address, uint256)) in calldata
    function decodeCurrencyAddressAndUint256(bytes calldata params)
        internal
        pure
        returns (Currency currency, address _address, uint256 amount)
    {
        assembly ("memory-safe") {
            currency := calldataload(params.offset)
            _address := calldataload(add(params.offset, 0x20))
            amount := calldataload(add(params.offset, 0x40))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, uint256)) in calldata
    function decodeCurrencyAndUint256(bytes calldata params)
        internal
        pure
        returns (Currency currency, uint256 amount)
    {
        assembly ("memory-safe") {
            currency := calldataload(params.offset)
            amount := calldataload(add(params.offset, 0x20))
        }
    }

    /// @dev equivalent to: abi.decode(params, (Currency, uint256, bool)) in calldata
    function decodeCurrencyUint256AndBool(bytes calldata params)
        internal
        pure
        returns (Currency currency, uint256 amount, bool boolean)
    {
        assembly ("memory-safe") {
            currency := calldataload(params.offset)
            amount := calldataload(add(params.offset, 0x20))
            boolean := calldataload(add(params.offset, 0x40))
        }
    }

    /// @notice Decode the `_arg`-th element in `_bytes` as `bytes`
    /// @param _bytes The input bytes string to extract a bytes string from
    /// @param _arg The index of the argument to extract
    function toBytes(bytes calldata _bytes, uint256 _arg) internal pure returns (bytes calldata res) {
        uint256 length;
        uint256 relativeOffset;
        assembly ("memory-safe") {
            // The offset of the `_arg`-th element is `32 * arg`, which stores the offset of the length pointer.
            // shl(5, x) is equivalent to mul(32, x)
            let lengthPtr := add(_bytes.offset, calldataload(add(_bytes.offset, shl(5, _arg))))
            // the number of bytes in the bytes string
            length := calldataload(lengthPtr)
            // the offset where the bytes string begins
            let offset := add(lengthPtr, 0x20)
            // the relative offset of the array from the calldata parameter
            relativeOffset := sub(offset, _bytes.offset)
            // assign the return parameters
            res.length := length
            res.offset := offset
        }
        if (_bytes.length < length + relativeOffset) revert SliceOutOfBounds();
    }

    /// @notice Decode the `_arg`-th element in `_bytes` as `bytes`
    /// @param _bytes The input bytes string to extract a bytes array from
    /// @param _arg The index of the argument to extract
    function toBytesArray(bytes calldata _bytes, uint256 _arg) internal pure returns (bytes[] calldata res) {
        uint256 encodingLength;
        bool isValidEncoding = true;
        assembly ("memory-safe") {
            let bytesOffset := and(_bytes.offset, OFFSET_OR_LENGTH_MASK)
            // The offset of the `_arg`-th element is `32 * arg`, which stores the offset of the length pointer.
            // shl(5, x) is equivalent to mul(32, x)
            let lengthPtr := add(bytesOffset, and(calldataload(add(bytesOffset, shl(5, _arg))), OFFSET_OR_LENGTH_MASK))
            // the number of byte strings in the byte array
            let arrayLength := and(calldataload(lengthPtr), OFFSET_OR_LENGTH_MASK)

            // check the array elements are encoded in order
            // end points at the slot after the offset of the final array element
            let end := add(lengthPtr, shl(5, add(arrayLength, 1)))
            // starting from index 1: for (i = 1; i < array.length, i++) {
            for { let memPtr := add(lengthPtr, 0x40) } lt(memPtr, end) { memPtr := add(memPtr, 0x20) } {
                // bool isValidEncoding = isValidEncoding & (offset[i-1] < offset[i])
                isValidEncoding := and(isValidEncoding, lt(calldataload(sub(memPtr, 0x20)), calldataload(memPtr)))
            }

            // pointer to encoding of the final bytes string in the array is `32 * arrayLength`
            let finalElementLengthPtr :=
                and(add(add(lengthPtr, 0x20), calldataload(sub(end, 0x20))), OFFSET_OR_LENGTH_MASK)
            // the length of the final bytes string
            let finalElementLength := and(calldataload(finalElementLengthPtr), OFFSET_OR_LENGTH_MASK)
            // the final bytes string's encoding is: 32 byte length, then the `length` bytes
            let finalElementEnd := add(add(finalElementLengthPtr, finalElementLength), 0x20)
            // total length needed in the calldata bytes array
            encodingLength := sub(finalElementEnd, bytesOffset)

            // the start of the bytes string encoding is the slot after the length
            let arrayOffset := add(lengthPtr, 0x20)
            res.length := arrayLength
            res.offset := arrayOffset
        }

        // check that the end of the variable length parameter is within the calldata provided
        if (_bytes.length < encodingLength || !isValidEncoding) revert SliceOutOfBounds();
    }
}
