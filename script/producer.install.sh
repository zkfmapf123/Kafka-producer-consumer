# !/bin/bash

## nginx
sudo amazon-linux-extras install nginx1 -y
sudo systemctl restart nginx
curl -vs localhost:80
