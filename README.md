#### ERC-20 代币标准

ERC-20 这是一个能实现智能合约中代币的应用程序接口标准。

ERC-20 的功能示例包括：

- 将代币从一个帐户转到另一个帐户
- 获取帐户的当前代币余额
- 获取网络上可用代币的总供应量
- 批准一个帐户中一定的代币金额由第三方帐户使用



#### 所需要实现的方法

```solidity

interface IERC20 {
		// 事件
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
    // 由某个账户地址向另一个账户地址转帐
    function transferForm(address form, address to, uint256 amount) external returns (bool);
}
```

从我的理解是有些像go语言的接口，实现ERC-20接口的方法便意味着这个智能合约实现了ERC20的代币标准。