// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.17;

// SECTION Ownable and reentrancy protection
contract protected {
    mapping(address => bool) is_auth;

    function authorized(address addy) public view returns (bool) {
        return is_auth[addy];
    }

    function set_authorized(address addy, bool booly) public onlyAuth {
        is_auth[addy] = booly;
    }

    modifier onlyAuth() {
        require(is_auth[msg.sender] || msg.sender == owner, "not owner");
        _;
    }
    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
    bool locked;
    modifier safe() {
        require(!locked, "reentrant");
        locked = true;
        _;
        locked = false;
    }

    function change_owner(address new_owner) public onlyAuth {
        owner = new_owner;
    }

    receive() external payable {}

    fallback() external payable {}
}

// !SECTION Ownable and reentrancy protection

// ANCHOR Main contract
contract Databasol is protected {
    // SECTION Structs
    struct ROW {
        uint256 id;
        mapping(string => bytes32) columns;
        mapping(uint256 => string) columns_index;
        uint256 columns_count;
    }

    struct TABLE {
        uint256 id;
        string name;
        mapping(uint256 => ROW) rows;
        uint256 rows_count;
    }

    mapping(string => TABLE) tables;
    mapping(uint256 => string) tables_ids;
    uint256 tables_count;

    // !SECTION Structs

    // SECTION Events

    event table_created(string name, uint256 id);
    event row_created(string table, uint256 id);
    event column_created(string table, uint256 row, string column);
    event column_updated(string table, uint256 row, string column);
    event row_deleted(string table, uint256 row);
    event table_deleted(string table);

    // !SECTION Events

    constructor() {
        owner = msg.sender;
        is_auth[msg.sender] = true;
    }

    // SECTION Main functions
    function create_table(string memory name) public onlyAuth {
        tables_ids[tables_count] = name;
        tables[name].id = tables_count;
        tables[name].name = name;
        tables_count++;
    }

    function create_row(string memory table_name, uint256 row_id)
        public
        onlyAuth
    {
        tables[table_name].rows[row_id].id = row_id;
        tables[table_name].rows_count++;
    }

    function set_column(
        string memory table_name,
        uint256 row_id,
        string memory column_name,
        bytes32 value
    ) public onlyAuth {
        tables[table_name].rows[row_id].columns[column_name] = value;
        tables[table_name].rows[row_id].columns_index[
            tables[table_name].rows[row_id].columns_count
        ] = column_name;
        tables[table_name].rows[row_id].columns_count++;
    }

    function get_column(
        string memory table_name,
        uint256 row_id,
        string memory column_name
    ) public view returns (bytes32) {
        return tables[table_name].rows[row_id].columns[column_name];
    }

    function get_table(string memory table_name)
        public
        view
        returns (bytes32[][] memory)
    {
        bytes32[][] memory table = new bytes32[][](
            tables[table_name].rows_count
        );
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            table[i] = get_row(table_name, i);
        }
        return table;
    }

    function get_tables_names() public view returns (bytes32[] memory) {
        bytes32[] memory tables_ = new bytes32[](tables_count);
        for (uint256 i = 0; i < tables_count; i++) {
            tables_[i] = bytes32(bytes(tables_ids[i]));
        }
        return tables_;
    }

    function get_table_rows_count(string memory table_name)
        public
        view
        returns (uint256)
    {
        return tables[table_name].rows_count;
    }

    function get_table_columns_count(string memory table_name)
        public
        view
        returns (uint256)
    {
        return tables[table_name].rows[0].columns_count;
    }

    function get_table_columns_names(string memory table_name)
        public
        view
        returns (bytes32[] memory)
    {
        bytes32[] memory columns = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = 0; i < tables[table_name].rows[0].columns_count; i++) {
            columns[i] = bytes32(
                bytes(tables[table_name].rows[0].columns_index[i])
            );
        }
        return columns;
    }

    function get_table_name(uint256 table_id) public view returns (bytes32) {
        return bytes32(bytes(tables_ids[table_id]));
    }

    function get_table_id(string memory table_name)
        public
        view
        returns (uint256)
    {
        return tables[table_name].id;
    }

    function get_row_id(string memory table_name, uint256 row_id)
        public
        view
        returns (uint256)
    {
        return tables[table_name].rows[row_id].id;
    }

    function get_column_name(
        string memory table_name,
        uint256 row_id,
        uint256 column_id
    ) public view returns (bytes32) {
        return
            bytes32(
                bytes(tables[table_name].rows[row_id].columns_index[column_id])
            );
    }

    function get_column_id(
        string memory table_name,
        uint256 row_id,
        string memory column_name
    ) public view returns (uint256) {
        for (
            uint256 i = 0;
            i < tables[table_name].rows[row_id].columns_count;
            i++
        ) {
            if (
                keccak256(
                    bytes(tables[table_name].rows[row_id].columns_index[i])
                ) == keccak256(bytes(column_name))
            ) {
                return i;
            }
        }
        return 0;
    }

    function get_column_id_by_name(
        string memory table_name,
        string memory column_name
    ) public view returns (uint256) {
        for (uint256 i = 0; i < tables[table_name].rows[0].columns_count; i++) {
            if (
                keccak256(bytes(tables[table_name].rows[0].columns_index[i])) ==
                keccak256(bytes(column_name))
            ) {
                return i;
            }
        }
        return 0;
    }

    function get_column_name_by_id(string memory table_name, uint256 column_id)
        public
        view
        returns (bytes32)
    {
        return
            bytes32(bytes(tables[table_name].rows[0].columns_index[column_id]));
    }

    function get_row_id_by_column_value(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (uint256) {
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                return i;
            }
        }
        return 0;
    }

    function get_row_id_by_column_value_and_column_id(
        string memory table_name,
        uint256 column_id,
        bytes32 value
    ) public view returns (uint256) {
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[column_id]
                ] == value
            ) {
                return i;
            }
        }
        return 0;
    }

    function get_row_id_by_column_value_and_column_name(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (uint256) {
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                return i;
            }
        }
        return 0;
    }

    function get_row_id_by_column_value_and_column_id_and_row_id(
        string memory table_name,
        uint256 column_id,
        bytes32 value,
        uint256 row_id
    ) public view returns (uint256) {
        for (uint256 i = row_id; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[column_id]
                ] == value
            ) {
                return i;
            }
        }
        return 0;
    }

    function get_row_id_by_column_value_and_column_name_and_row_id(
        string memory table_name,
        string memory column_name,
        bytes32 value,
        uint256 row_id
    ) public view returns (uint256) {
        for (uint256 i = row_id; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                return i;
            }
        }
        return 0;
    }

    function get_row(string memory table_name, uint256 row_id)
        public
        view
        returns (bytes32[] memory)
    {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[row_id].columns_count
        );
        for (
            uint256 i = 0;
            i < tables[table_name].rows[row_id].columns_count;
            i++
        ) {
            row[i] = tables[table_name].rows[row_id].columns[
                tables[table_name].rows[row_id].columns_index[i]
            ];
        }
        return row;
    }

    function get_row_by_column_value(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (bytes32[] memory) {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    row[j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                return row;
            }
        }
        return row;
    }

    function get_row_by_column_value_and_column_id(
        string memory table_name,
        uint256 column_id,
        bytes32 value
    ) public view returns (bytes32[] memory) {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[column_id]
                ] == value
            ) {
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    row[j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                return row;
            }
        }
        return row;
    }

    function get_row_by_column_value_and_column_name(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (bytes32[] memory) {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    row[j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                return row;
            }
        }
        return row;
    }

    function get_row_by_column_value_and_column_id_and_row_id(
        string memory table_name,
        uint256 column_id,
        bytes32 value,
        uint256 row_id
    ) public view returns (bytes32[] memory) {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = row_id; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[column_id]
                ] == value
            ) {
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    row[j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                return row;
            }
        }
        return row;
    }

    function get_row_by_column_value_and_column_name_and_row_id(
        string memory table_name,
        string memory column_name,
        bytes32 value,
        uint256 row_id
    ) public view returns (bytes32[] memory) {
        bytes32[] memory row = new bytes32[](
            tables[table_name].rows[0].columns_count
        );
        for (uint256 i = row_id; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    row[j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                return row;
            }
        }
        return row;
    }

    function get_rows(string memory table_name)
        public
        view
        returns (bytes32[][] memory)
    {
        bytes32[][] memory rows = new bytes32[][](
            tables[table_name].rows_count
        );
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            rows[i] = new bytes32[](tables[table_name].rows[i].columns_count);
            for (
                uint256 j = 0;
                j < tables[table_name].rows[i].columns_count;
                j++
            ) {
                rows[i][j] = tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[j]
                ];
            }
        }
        return rows;
    }

    function get_rows_by_column_value(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (bytes32[][] memory) {
        bytes32[][] memory rows = new bytes32[][](
            tables[table_name].rows_count
        );
        uint256 rows_count = 0;
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                rows[rows_count] = new bytes32[](
                    tables[table_name].rows[i].columns_count
                );
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    rows[rows_count][j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                rows_count++;
            }
        }
        return rows;
    }

    function get_rows_by_column_value_and_column_id(
        string memory table_name,
        uint256 column_id,
        bytes32 value
    ) public view returns (bytes32[][] memory) {
        bytes32[][] memory rows = new bytes32[][](
            tables[table_name].rows_count
        );
        uint256 rows_count = 0;
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[column_id]
                ] == value
            ) {
                rows[rows_count] = new bytes32[](
                    tables[table_name].rows[i].columns_count
                );
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    rows[rows_count][j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                rows_count++;
            }
        }
        return rows;
    }

    function get_rows_by_column_value_and_column_name(
        string memory table_name,
        string memory column_name,
        bytes32 value
    ) public view returns (bytes32[][] memory) {
        bytes32[][] memory rows = new bytes32[][](
            tables[table_name].rows_count
        );
        uint256 rows_count = 0;
        for (uint256 i = 0; i < tables[table_name].rows_count; i++) {
            if (tables[table_name].rows[i].columns[column_name] == value) {
                rows[rows_count] = new bytes32[](
                    tables[table_name].rows[i].columns_count
                );
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    rows[rows_count][j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                rows_count++;
            }
        }
        return rows;
    }

    function get_rows_by_column_value_and_row_id(
        string memory table_name,
        bytes32 value,
        uint256 row_id
    ) public view returns (bytes32[][] memory) {
        bytes32[][] memory rows = new bytes32[][](
            tables[table_name].rows_count
        );
        uint256 rows_count = 0;
        for (uint256 i = row_id; i < tables[table_name].rows_count; i++) {
            if (
                tables[table_name].rows[i].columns[
                    tables[table_name].rows[i].columns_index[0]
                ] == value
            ) {
                rows[rows_count] = new bytes32[](
                    tables[table_name].rows[i].columns_count
                );
                for (
                    uint256 j = 0;
                    j < tables[table_name].rows[i].columns_count;
                    j++
                ) {
                    rows[rows_count][j] = tables[table_name].rows[i].columns[
                        tables[table_name].rows[i].columns_index[j]
                    ];
                }
                rows_count++;
            }
        }
        return rows;
    }
    // !SECTION Main functions
}
