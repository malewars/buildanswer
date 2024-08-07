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