```json
{
  "iss": "https://auth.test-one-pingone.com/eb41e805-36a5-47df-af01-c5235f410c8e/as",
  "sub": "RY9lAKHZTB1Y4zVtBlXC4iRCS6Jk0p4oONUsp4zMcDI",
  "aud": "b5c4f367-33dc-4931-b84f-baaccfc510b4",
  "iat": 1721834196,
  "exp": 1721837796,
  "acr": "possessionorinherence",
  "amr": [
    "otp"
  ],
  "auth_time": 1721834195,
  "nonce": "AwABEgEAAAACAOz_BQD0_wNO5_NpeJ0n1bttaLyoR4dw7D4rG3Yw1GHFiE4RXodUUp2BWxhml3qletfSUZ_Kqnwi1qlpLvME2fShiXR2uYQgAA",
  "sid": "c0a76b09-50bc-404b-aa53-0ab2f2f508fd",
  "env": "eb41e805-36a5-47df-af01-c5235f410c8e",
  "org": "43e202c5-cc02-4eba-8381-ed310d3c2f0d",
  "p1.region": "NA1"
}
```

* https://docs.pingidentity.com/r/en-us/pingone/pingone_edit_application_oidc

* https://docs.pingidentity.com/r/en-us/pingfederate-112/pf_openid_provider_config_endpoint
* https://docs.pingidentity.com/r/en-us/pingone/p1_t_editcustomidtokenmapping
* https://apidocs.pingidentity.com/pingone/platform/v1/api/src/authentication-apis/openid-connect-oauth-2/authorize-intro/
While triggering the flow, they send response_mode=pi.flow  in the requestParams
```
  requestParams=redirectUri,<snip> ...</snip>,userID,riskLevel,firstTimeSignIn,<snip> ...</snip>,acr_values,response_type,redirect_uri,response_mode,<snip> ...</snip>,client_id,MFADevice,riskEvalID

OR 

requestParams=acr_values,response_type,redirect_uri,scope,response_mode,<snip>...
```
* Managing the auth req and response
```
SAML applications can request a lower-priority policy by sending a SAML 2.0 authentication request with the RequestedAuthnContext parameter, where the value indicates the desired PingOne authentication name or DaVinci flow policy ID. Note that the enableRequestAuthnContext must be set to true for the SAML application

example: using davini in p1

1) Create the new flow
2) Enable PingOne SSO button
3) Add Flow to an application in DaVinci:
4) Grab the Policy ID
Policy ID: 1f98d450834abe2defa8d3462a6c0405

Build the app and select the Da Vinci Policy id ->
+ Add Policy
+ Click Da Vinci Policies 
```

![image](https://github.com/user-attachments/assets/5ed254f4-930f-45bf-bb98-3ee2f6798840)
![image](https://github.com/user-attachments/assets/321162a6-fffa-4b2b-bcfb-434f1e5956d4)
![image](https://github.com/user-attachments/assets/fd093262-02b5-4e22-b36f-032041d05cb1)
![image](https://github.com/user-attachments/assets/c7202fb2-8383-43db-85b2-8ecd1c642fae)

```
policyId-58f4ba351b36b716e3811c0c1371b080

https://auth.pingone.com/3830071f-dce6-4768-a0e4-fed7dc2de6b2/davinci/policy/12260acfb11e99d1b88afbdb3cba4baf/authorize?client_id=ac0e86c48369a33f18dd3234367d316b&redirect_uri=https://auth.pingone.com/3830071f-dce6-4768-a0e4-fed7dc2de6b2/rp/callback/openid_connect&state=00bba4b3-0045-4e13-9070-19b21b0936a0&response_type=code&scope=openid%20profile&nonce=00bba4b3-0045-4e13-9070-19b21b0936a0


https://auth.pingone.com/3830071f-dce6-4768-a0e4-fed7dc2de6b2/davinci/policy/58f4ba351b36b716e3811c0c1371b080/authorize?client_id=ac0e86c48369a33f18dd3234367d316b&redirect_uri=https://auth.pingone.com/3830071f-dce6-4768-a0e4-fed7dc2de6b2/rp/callback/openid_connect&state=004b27d6-ea0e-41e9-852c-c1440291d518&response_type=code&scope=openid%20profile&acr_values=policyId%2F58f4ba351b36b716e3811c0c1371b080&nonce=004b27d6-ea0e-41e9-852c-c1440291d518
```
