
#!/bin/bash
echo "Installing dependencies..."
sudo apt update 2>/dev/null || true
sudo apt install -y python3 python3-pip nodejs npm || true
pip3 install flask websockets
echo "Done."
