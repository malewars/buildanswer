```
Prerequisite
Windows VM and browser configured for Kerberos

See Setup Kerberos authentication for Gateways 

PingOne has LDAP Gateway with Kerberos authentication enabled

PingOne has Authentication policy using LDAP Gateway with Kerberos authentication enabled

Install Fiddler
Install Fiddler Classic on the Windows VM where Kerberos SSO will be in triggered using a browser

Configure Fiddler to decrypt HTTPS traffic

 See Trust FiddlerRoot Certificate - Fiddler Classic

 See for configuring Firefox Capture HTTPS traffic from Firefox - Fiddler Classic 

Troubleshooting
Launch Fiddler Classic and start capturing network traffic

Launch a browser and navigate to PingOne to trigger Kerberos authentication

Inspect network traffic captured by Fiddler

The response from /{envId}/flows/{flowId} should include a kerberos.authenticate link
```
![image](https://github.com/user-attachments/assets/b968bd1a-e949-4e42-9e02-4a9ec3d86983)

```
If kerberos.authenticate link is missing, check that

LDAP Gateway has Kerberos authentication enabled

Authentication policy is using LDAP Gateway with Kerberos authentication enabled

The response from /{envId}/flows/{flowId}/kerberos should be 401 Unauthorized and include www-authenticate: Negotiate header
```
![image](https://github.com/user-attachments/assets/65af49a7-5f65-44c2-8b31-2b7ca5cc769f)

```
If www-authenticate: Negotiate header is missing, then it could be an issue in the platform (Amazon API Gateway, CloudFront, or CloudFlare whenever we’ve migrated over to it)

For example, www-authentication header is not being added back to the response header after it’s been renamed. See STAGING-19864: Kerberos failing on LDAP Gateway
Closed
 

[Scenario 1] The subsequent request to /{envId}/flows/{flowId}/kerberos should include a Authorization: Negotiate <kerberos token> header
```
![image](https://github.com/user-attachments/assets/0bf3d735-0709-4ad9-b282-712d8141181b)
```
If Authorization: Negotiate <kerberos token> header is missing, check that service principal names (SPNs) are configured and the browser is configured correctly for kerberos negotiation.

See Kerberos authentication

[Scenario 2] There isn’t a subsequent request to /{envId}/flows/{flowId}/kerberos and the browser falls back to the PingOne username/password login form
```
![image](https://github.com/user-attachments/assets/a1617435-fcb9-4aa0-b686-9e745f62ca88)
```
If there isn’t a subsequent request to /{envId}/flows/{flowId}/kerberos, check that the browser is configured correctly for kerberos negotiation.

[Scenario 3] The subsequent request to /{envId}/flows/{flowId}/kerberos includes a Authorization: Negotiate <kerberos token> header and the response is 401 Unauthorized
```
![image](https://github.com/user-attachments/assets/eca0a302-fe97-4ee1-9ca1-cc5e90e135f1)
```
Use the correlation ID to search for logs in Splunk.

[Scenario 3.1] If the error is Checksum failed, then check that the service account credentials entered in LDAP Gateway is the same account used to configure service principal names (SPNs) in the Domain Controller by the setspn -S HTTP/<regionalPingOneAddress> <sAMAcccountName>



If you make any changes to service account settings in AD, the end-user must log out and login again to their Windows machine for the new service account settings to take effect



2023-09-22T20:06:18.676Z level=INFO  thread=http-nio-8080-exec-5 component=c.p.l.s.k.KerberosService correlationId=ac2c8078-10fa-4499-8553-25ce0fd64296
 envId=aec15f31-d16a-460c-865b-a02bd695959d envName=Administrators envType=PRODUCTION envRegion=CA orgId=b3bb0a24-3615-4f1b-b37e-6f35e6829114
 orgName=internal_kevinpak-one_713856590 orgType=INTERNAL requestId=9c6dc25e-a229-4d43-990c-21a580b2d1c9 requestClientId=flow-orchestration
 requestingServiceName=flow-orchestration requestingServiceDeploymentId=57701 |
 Unable to validate kerberos token. gatewayId=ce8536d8-3cf9-47be-8756-e1888d4cc049 org.ietf.jgss.GSSException:
 Failure unspecified at GSS-API level (Mechanism level: Checksum failed)
		at sun.security.jgss.krb5.Krb5Context.acceptSecContext(Krb5Context.java:858)
		at sun.security.jgss.GSSContextImpl.acceptSecContext(GSSContextImpl.java:342)
		at sun.security.jgss.GSSContextImpl.acceptSecContext(GSSContextImpl.java:285)
		at com.pingidentity.lightning.service.kerberos.KerberosService.checkKerberosServiceTicketByKerberosCredential(KerberosService.java:201)
		at com.pingidentity.lightning.service.kerberos.KerberosService.checkKerberosServiceTicket(KerberosService.java:160)
		at com.pingidentity.lightning.service.kerberos.KerberosService.lookupUser(KerberosService.java:257)
		at com.pingidentity.lightning.controller.LdapGatewayController.doLookupUserByKerberosServiceTicket(LdapGatewayController.java:313)
		at com.pingidentity.lightning.controller.LdapGatewayController.lookupUserByKerberosServiceTicket(LdapGatewayController.java:257)
		at com.pingidentity.lightning.controller.LdapGatewayController$$FastClassBySpringCGLIB$$e34b14dc.invoke(<generated>)
Part of the service account credential validation should be to ensure the domain of the service account matches the domain that the KDC creates the token for. 

AES256 is case-sensitive. Check for correct capitalization!
```
![image](https://github.com/user-attachments/assets/95fb957e-4853-4f1d-8e60-7f7b3828db8d)

![image](https://github.com/user-attachments/assets/7d5e31eb-7232-49fc-8934-bbb7915d0a7a)
```
[Scenario 3.2] If the error is Invalid argument (400) - Cannot find key of appropriate type to decrypt AP REP - RC4 with HMAC, then check that the service account has the following encryption options enabled
```
![image](https://github.com/user-attachments/assets/edab270f-f600-43bc-8a76-ea6e7dfe374e)

```
If you make any changes to service account settings in AD, the end-user must log out and login agin to their Windows machine for the new service account settings to take effect



2023-09-22T20:12:27.578Z level=INFO  thread=http-nio-8080-exec-8 component=c.p.l.s.k.KerberosService correlationId=b308bc60-9b73-4993-a9e8-377eef7d0e9e
 envId=aec15f31-d16a-460c-865b-a02bd695959d envName=Administrators envType=PRODUCTION envRegion=CA orgId=b3bb0a24-3615-4f1b-b37e-6f35e6829114
 orgName=internal_kevinpak-one_713856590 orgType=INTERNAL requestId=2710e97b-476f-4f52-aa17-3d87bdcea266 requestClientId=flow-orchestration 
 requestingServiceName=flow-orchestration requestingServiceDeploymentId=57701 | 
 Unable to validate kerberos token. gatewayId=ce8536d8-3cf9-47be-8756-e1888d4cc049 org.ietf.jgss.GSSException:
 Failure unspecified at GSS-API level (Mechanism level: Invalid argument (400) -
 Cannot find key of appropriate type to decrypt AP REP - RC4 with HMAC)
		at sun.security.jgss.krb5.Krb5Context.acceptSecContext(Krb5Context.java:858)
		at sun.security.jgss.GSSContextImpl.acceptSecContext(GSSContextImpl.java:342)
		at sun.security.jgss.GSSContextImpl.acceptSecContext(GSSContextImpl.java:285)
		at com.pingidentity.lightning.service.kerberos.KerberosService.checkKerberosServiceTicketByKerberosCredential(KerberosService.java:201)
		at com.pingidentity.lightning.service.kerberos.KerberosService.checkKerberosServiceTicket(KerberosService.java:160)
		at com.pingidentity.lightning.service.kerberos.KerberosService.lookupUser(KerberosService.java:257)
		at com.pingidentity.lightning.controller.LdapGatewayController.doLookupUserByKerberosServiceTicket(LdapGatewayController.java:313)
		at com.pingidentity.lightning.controller.LdapGatewayController.lookupUserByKerberosServiceTicket(LdapGatewayController.java:257)
[Scenario 4] The subsequent request to /{envId}/flows/{flowId}/kerberos includes a Authorization: Negotiate <token> header and the response is 401 Unauthorized. Browser prompts a window for username and password and token in the Authorization header is a NTLM token. 
```
![image](https://github.com/user-attachments/assets/29f755e5-7460-4f60-a88f-4e7bafb10e94)
```
Kerberos tokens typically start with YII.... In the example below, the token starts with TlRMT...
```
![image](https://github.com/user-attachments/assets/699a2fbb-b87a-47c5-917c-129e6dff39d7)
```
Check that the browser is configured correctly for Kerberos negotiation.
```


```
