# Masternode Installation Script

# Part 1 - Sending Collateral Coins

1. Open your Windows wallet and unlock if your wallet is encrypted - MAKE SURE IT IS FULLY SYNCED WITH THE NETWORK AND STAKING IS DISABLED
2. Go to Settings -> Debug -> Console
3. Type: getnewaddress name (name is your address name that you want to use. Example: mywallet)
4. Send 10,000 JHL to this address and wait for at least 1 confirmation (Collateral changes according to Collateral and reward Table, check on website).
5. Go to MASTERNODES -> Create Masternode Controller -> Next -> Set Masternode Name <e.g MN1> -> Set Masternode IP <VPS IP>
6. Wait for status of your controller be MISSING
7. Go to Jericoin's location (e.g C:\Users\user1\AppData\Roaming\Jericoin)
8. Open masternode.conf file
9. Copy masternodeprivkey from masternode.conf since we need it to start VPS Masternode (usually its format is 
    '''[alias] [ip]:31357 [masternodeprivkey] [transactionId] [index]''' )
10. Close the wallet
11. Move to Part 2 for now

# Part 2 - Getting your Linux VPS Started Up (Read all instructions and follow prompts closely)

1. Connect to your linux vps AS ROOT, copy and paste the following line into your VPS. Double click to highlight the entire line, copy it, and right click into Putty or Shift + Insert to paste or other button combinations depends on the shell application or your system operation.
```
bash <( curl -sL https://raw.githubusercontent.com/JericoinProject/startmasternode/main/mninstall.sh)
```
2. follow the prompts closely and don't mess it up!
3. Move to Part 3

# Part 3 - Starting the Masternode

1. In your wallet, go to Masternode tab
2. Click on the masternode you just created and click start
3. Enjoy! You can start this process over again for another MN on a fresh Linux VPS!

# Part 4 - Checking Masternode Status

1. After running the step 3, go back to your VPS
2. Tip this command: jericoin-cli startmasternode local false
3. Enter ```cd``` to get back to your root directory
4. Enter ```tutela-cli getmasternodestatus```
5. This will tell you the status of your masternode, any questions, Join discord for help: https://discord.gg/xuEVagA8AT

# Recommended Tools

- Putty - Easy to use and customizable SSH client.
- SuperPutty - This allows you to have multiple Putty tabs open in one window, allowing you to easily organize and switch between masternode servers.

# Troubleshooting
Output on VPS shows Not capable Masternode: Hot node, waiting for remote activation:
    - On VPS tip this command: jericoin-cli stop
    - Close main Wallet (e.g windows wallet)
    - On VPS tip: jericoind
    - Open main Wallet (e.g windows wallet)
    - Execute Part 3
