a solidity ^0.8.17;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    // 部署者的初始总共多少钱
    function totalSupply() external view returns (uint256);
    // 查询某个账户地址的余额
    function balanceOf(address account) external view returns (uint256);
    // 由协议调用者向某个地址转账
    function transfer(address to, uint256 amount) external returns (bool);
    // 获取授权者的额度
    function allowance(address owner, address spender) external returns (uint256);
    // 协议调用者授权某个账户多少钱
    function approval(address spender, uint256 amount) external returns (bool);
    
    function transferForm(address form, address to, uint256 amount) external returns (bool);
}

contract ERC20 is IERC20 {
    
    uint256 _total;
    mapping (address=>uint256) _address2balance;
    mapping (address => mapping (address=>uint256)) _approvalAmount;
    string _name;
    string _symbol;
    address _owner;

    constructor (string memory name_, string memory symbol_) {
        _total = 10000;
        _address2balance[msg.sender] = _total;
        _name = name_;
        _symbol = symbol_;
        _owner = msg.sender;
    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8){
        return 18;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "err: only owner call func");
        _;
    }

    // 铸造代币
    function mint(address account, uint256 amount) public onlyOwner returns (bool){
        require(account != address(0), "err: account is 0 addresss");
        _total += amount;
        _address2balance[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    // 销毁代币
    function burn(address account, uint256 amount) public onlyOwner{
        require(account != address(0), "err: account is 0 addresss");
        uint256 targeAmount = _address2balance[account];
        require(targeAmount >= amount, "err: account not enougt amount burn");
        _total -= amount;
        _address2balance[account] = targeAmount- amount;
        emit Transfer(account, address(0), amount);
    }



    function totalSupply() public view returns (uint256) {
        return _total;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _address2balance[account];
    }

    function _transfer(address form, address to, uint256 amount)  internal returns (bool) {
        uint256 curAmount = _address2balance[form];
        require (to != address(0), "address is 0");
        require (curAmount >= amount, "balance not enough transfer");
        _address2balance[form] = curAmount - amount;
        _address2balance[to] = amount;
        emit Transfer(form, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        return _transfer(msg.sender, to, amount);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _approvalAmount[owner][spender];
    }

    function approval(address spender, uint256 amount) public returns (bool) {
        require(msg.sender != spender, "is owner approval owner");
        _approvalAmount[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferForm(address form, address to, uint256 amount) public returns (bool){
       uint256 approvalAmount = _approvalAmount[form][msg.sender];
       require(approvalAmount >= amount, "err: not enough approval amount transfer");
        
        bool ok = transfer(to, amount);
        require(ok != false, "err: transfer fail");
        _approvalAmount[form][msg.sender] = approvalAmount - amount;
        emit Approval(form, msg.sender, amount);
        return true;
    }
}
