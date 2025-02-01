# !bin/bash

echo "Hello, World!"

# Variables
NAME="John"
AGE=20

echo "Name: $NAME"
echo "Age: $AGE"

# Functions
function greet() {
    echo "Hello, $1!"
}

greet "John"

# Conditionals
if [ $AGE -ge 18 ]; then
    echo "You are an adult."
else
    echo "You are a minor."
fi

# Loops
for i in 1 2 3; do
    echo "Number: $i"
done


# Arrays
NAMES=("John" "Jane" "Jim")

echo "First name: ${NAMES[0]}"
echo "All names: ${NAMES[@]}"

# Reading user input
read -p "Enter your name: " NAME
echo "Hello, $NAME!"

# File operations
touch newfile.txt
echo "Hello, World!" > newfile.txt
cat newfile.txt

# Command line arguments
echo "First argument: $1"
echo "Second argument: $2"

# Redirecting output
ls > output.txt

# Appending to a file
echo "Hello, World!" >> newfile.txt

# Reading from a file
cat newfile.txt
less newfile.txt # for scrolling through a file

# Wildcards
ls *.txt

# Process management
ps aux | grep bash

# Background processes
sleep 10 &

# Trap signals
trap "echo 'Received SIGINT signal'" SIGINT

# Other commands

# find
find . -name "*.txt" # finds files with a specific extension

# grep
grep "Hello" newfile.txt # searches for a string in a file

# sed
sed 's/Hello/Hi/' newfile.txt # substitutes a string in a file

# awk
awk '{print $1}' newfile.txt # prints the first field of a file

# xargs
xargs echo "Hello" # executes a command with arguments

# kill
kill -9 1234 # ends a process

# tar
tar -czvf archive.tar.gz newfile.txt # creates a tarball

# zip
zip -r archive.zip newfile.txt # creates a zip file

# curl
curl -O https://example.com/file.txt # downloads a file

# wget
wget https://example.com/file.txt # downloads a file

# ssh
ssh user@host # connects to a remote server

# scp
scp user@host:/path/to/file.txt /path/to/local/file.txt # copies a file to a remote server

# rsync
rsync -av /path/to/source/ /path/to/destination/ # synchronizes files between two directories

# systemctl
systemctl start service # starts a service
systemctl stop service # stops a service
systemctl restart service # restarts a service

# All curl commands

curl -O https://example.com/file.txt # downloads a file
curl -X POST https://example.com/api/data # sends a POST request
curl -H "Content-Type: application/json" -X POST -d '{"name": "John", "age": 20}' https://example.com/api/data # sends a POST request with JSON data
curl -X GET https://example.com/api/data # sends a GET request
curl -X DELETE https://example.com/api/data # sends a DELETE request
curl -X PUT https://example.com/api/data # sends a PUT request
curl -X PATCH https://example.com/api/data # sends a PATCH request
curl -X OPTIONS https://example.com/api/data # sends an OPTIONS request

# Curl with query parameters
curl "https://api.example.com/data?param1=value1&param2=value2" # sends a GET request with query parameters 

# Curl with headers
curl -H "Authorization: Bearer your_token" https://api.example.com/data # sends a GET request with headers

# Curl with basic authentication
curl -u username:password https://api.example.com/data # sends a GET request with basic authentication

# Curl with cookies
curl -c cookies.txt https://example.com/login # sends a GET request and saves cookies to a file

# Curl with cookies
curl -b cookies.txt https://example.com/profile # sends a GET request with cookies



