# buildanswer
Short script to help create the file for the Terraform MasterFlow, updates to come but the idea is to create the administrator account in PingOne and return the text blob that needs to updated in order to use the DaVinci Master Flows.

MasterFlow: https://github.com/curtismu7/Master-Flow/tree/Master-Flow-1.1
       
Example run (with a blank variables file):
./buildanswer.sh

       Type Administrative Env ID:
       529xx667-eax0-46xx-bxxx-4axxxxx05289
       Type Worker AppID:
       a2xxx65-1ecb-4e48-bc79-04xxxx22a01
       Type Worker Secret:
       MySecret

Please create the new Terraform Admin Role and assign it to MasterFlowAdmin's account.

Also, verify the new Admin's email address

--------------------

Your terraform file should be this:

       admin_environment_id      = "529xx667-eax0-46xx-bxxx-4axxxxx05289"
       admin_client_id           = "a2xxx65-1ecb-4e48-bc79-04xxxx22a01"
       admin_client_secret       = "MySecret"
       region                    = "NorthAmerica"
       license_name              = "INTERNAL"
       admin_user_id             = "INSERT-YOUR-ID"
       dv_admin_username         = "MasterFlowAdmin
       dv_admin_password         = "MyR3ndomPAsswd!"
       organization_id           = "529xx667-eax0-46xx-bxxx-4axxxxx05289"
