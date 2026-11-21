"""
XBM Token Monitoring Script
Python security/monitoring tool for the XBM cryptocurrency
"""

from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

# Configuration
RPC_URL = os.getenv("RPC_URL", "https://eth-sepolia.g.alchemy.com/v2/YOUR_KEY")
CONTRACT_ADDRESS = os.getenv("XBM_ADDRESS", "0x...")  # Set after deployment
LARGE_TRANSFER_THRESHOLD = 1_000_000 * 10**18  # 1M tokens

# Minimal ABI for Transfer event
TRANSFER_ABI = [
    {
        "anonymous": False,
        "inputs": [
            {"indexed": True, "name": "from", "type": "address"},
            {"indexed": True, "name": "to", "type": "address"},
            {"indexed": False, "name": "value", "type": "uint256"}
        ],
        "name": "Transfer",
        "type": "event"
    }
]

def monitor_transfers():
    """Monitor XBM token transfers for large movements"""
    w3 = Web3(Web3.HTTPProvider(RPC_URL))
    
    if not w3.is_connected():
        print("Failed to connect to RPC")
        return
    
    contract = w3.eth.contract(address=Web3.to_checksum_address(CONTRACT_ADDRESS), abi=TRANSFER_ABI)
    
    print(f"Monitoring XBM transfers at {CONTRACT_ADDRESS}")
    print(f"Alert threshold: {LARGE_TRANSFER_THRESHOLD / 10**18:,.0f} XBM")
    print("-" * 50)
    
    # Get recent transfers (last 100 blocks)
    latest_block = w3.eth.block_number
    from_block = max(0, latest_block - 100)
    
    events = contract.events.Transfer.get_logs(fromBlock=from_block, toBlock='latest')
    
    for event in events:
        value = event['args']['value']
        from_addr = event['args']['from']
        to_addr = event['args']['to']
        
        if value >= LARGE_TRANSFER_THRESHOLD:
            print(f"🚨 LARGE TRANSFER DETECTED")
            print(f"   From: {from_addr}")
            print(f"   To:   {to_addr}")
            print(f"   Amount: {value / 10**18:,.2f} XBM")
            print(f"   Tx: {event['transactionHash'].hex()}")
            print()

if __name__ == "__main__":
    monitor_transfers()
