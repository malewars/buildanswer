#!/bin/sh

myclient=`grep myclient variables | awk -F\" '{print $2}'`
uname="MasterFlowAdmin"
client_secret=`grep client_secret variables | awk -F\" '{print $2}'`
ENVID=`grep ENVID variables | awk -F\" '{print $2}'`
DEBUG=`grep DEBUG variables | awk -F\" '{print $2}'`
#ENVID="52988667-ea80-4602-b171-4a8202905289"
#myclient="a29c9865-1ecb-4e48-bc79-046083922a01"
#client_secret="V2yoEKHdAGRxhlRLH6fiqHI47n503GyYOkJtHLg6o04T6uMiPdtorZ0ezFdeOMKK"

if [[ $DEBUG == "YES" ]] ;
 then
  export CURLCMD="curl --location"
 else
  export CURLCMD="curl -s -o --location"
fi

if [[ $ENVID  == "ENVID" ]];
 then 
  echo "Type Administrative Env ID: "; read ENVID
fi

if [[ $myclient == "CLIENTID" ]];
 then 
  echo "Type Worker AppID: "; read myclient
fi

if [[ $client_secret == "CLIENTSECRET" ]];
 then 
  echo "Type Worker Secret: "; read client_secret
fi
TOKEN=`./gettoken.py $myclient $client_secret $ENVID | grep access_token | awk -F\" '{print $4}'`

#Get the administrative population id
adminID=` curl -s --location --request GET 'https://api.pingone.com/v1/environments/'"$ENVID"'/populations' --header 'Authorization: Bearer '"$TOKEN"' ' | grep "id.*," | awk -F\" '{print $4}'`

# DEBUG LINE popID=` curl --trace-ascii -vv --location --request GET 'https://api.pingone.com/v1/environments/'"$ENVID"'/populations' --header 'Authorization: Bearer '"$TOKEN"' ' | egrep "id|name" | grep  "," | awk 'ORS=/^.*id/?",":RS' | grep Population | awk -F\" '{print $4}' `
popID=` curl -s --location --request GET 'https://api.pingone.com/v1/environments/'"$ENVID"'/populations' --header 'Authorization: Bearer '"$TOKEN"' ' | egrep "id|name" | grep  "," | awk 'ORS=/^.*id/?",":RS' | grep Population | awk -F\" '{print $4}' `


#NEWADMIN=`./createterraadmin.py $TOKEN`
$CURLCMD --request POST 'https://api.pingone.com/v1/environments/'"$ENVID"'/users' \
--header 'Authorization: Bearer '"$TOKEN"'' \
--header 'Content-Type: application/vnd.pingidentity.user.import+json' \
--data-raw '{
    "email": "newterraformadmin1@mailinator.com",
    "name": {
        "given": "Terraform",
        "family": "MasterFlow"
    },
    "population": {
        "id": "'"$popID"'"
    },
    "lifecycle": {
      "status": "ACCOUNT_OK",
      "suppressVerificationCode": true
  },
    "username": "'"$uname"'",
    "password": {
        "value": "MyR3ndomPAsswd!",
        "forceChange": false
    }
}'

echo "Please create the new Terraform Admin Role and assign it to $uname"
echo "Also, verify the new Admin's email address"
echo "--------------------"
#echo $TOKEN

echo "Your terraform file should be this:"
echo ""
echo "admin_environment_id      = \"$ENVID\" "
echo "admin_client_id           = \"$myclient\" "
echo "admin_client_secret       = \"$client_secret\" "
echo "region                    = \"NorthAmerica\" "
echo "license_name              = \"INTERNAL\" "
echo "admin_user_id             = \"INSERT-YOUR-ID\" "
echo "dv_admin_username         = \"$uname "
echo "dv_admin_password         = \"MyR3ndomPAsswd!\" "
echo "organization_id           = \"$ENVID\" "
