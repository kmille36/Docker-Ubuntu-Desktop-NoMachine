wget -O ng.sh https://bit.ly/GCngrok > /dev/null 2>&1
chmod +x ng.sh
./ng.sh
clear
echo "======================="
echo "choose ngrok region (for better connection)."
echo "======================="
echo "us - United States (Ohio)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " CRP
./ngrok tcp --region $CRP 4000 &>/dev/null &
docker run --rm -d -p 4000:4000 --privileged --name nomachine-mate -e PASSWORD=123456 -e USER=user --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:mate
echo Done! NoMachine Information:
echo IP Address:
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p' 
echo User: user
echo Passwd: 123456
