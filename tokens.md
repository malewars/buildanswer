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
```
Terraform refresh
Terraform show will expand 

# data.local_file.get_token:
data "local_file" "get_token" {
    content              = <<-EOT
        eyJhbGciOiJSUzI1NiIsImtpZCI6ImRlZmF1bHQifQ.eyJjbGllbnRfaWQiOiIzNWI1YTg2YS00YjhiLTRjYmYtYTc1ZC0zYTMzYzlmNTc0NWMiLCJpc3MiOiJodHRwczovL2F1dGgucGluZ29uZS5jb20vNzM3YmM5OWEtZWQ5Ny00Y2QyLTljZTUtM2ZlMmFiNzI2MGE1L2FzIiwianRpIjoiMTdmMTExNmItMjk0Mi00MmVhLThjMTUtM2MyNjkyZGI1ZTFiIiwiaWF0IjoxNzIzMDUxMzEzLCJleHAiOjE3MjMwNTQ5MTMsImF1ZCI6WyJodHRwczovL2FwaS5waW5nb25lLmNvbSJdLCJlbnYiOiI3MzdiYzk5YS1lZDk3LTRjZDItOWNlNS0zZmUyYWI3MjYwYTUiLCJvcmciOiJmNDk5ZDhmMi04Y2Y1LTRmMTgtOWRiNS04MzZhMzhiNzY1ZTYifQ.UyDLnmSaSuoTMo0o4Kc6yfRzsYSj0wtnEqHkv351Tly99sh0LElaamHlROX_g3-mIkWUVPOMzXcRzhs81SHhGTytz0DBHfSydtanrukXil7iyhRtpRqEF9EWGORVS7E2woBv0SwIhRmklDYtul4HoiL7RFkVH6cSxaIFWwokKQ4s_UMa1xmqWSmqTSRbSSepTV7jo6R4HJgVgNYDd68YZ2-lGG5Jj2fzqacW47BCVxOxCqMSQOXclNa-OY0WuE0OIwvivM3rfpjm_c5Mr1pNq3QoVnM6KRrCCFiHdID_P3JTgiR1mGelEO3RSaCSOeoFgNe4qcq7GBYarR1hYf0PPQ
    EOT
    content_base64       = "ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkltUmxabUYxYkhRaWZRLmV5SmpiR2xsYm5SZmFXUWlPaUl6TldJMVlUZzJZUzAwWWpoaUxUUmpZbVl0WVRjMVpDMHpZVE16WXpsbU5UYzBOV01pTENKcGMzTWlPaUpvZEhSd2N6b3ZMMkYxZEdndWNHbHVaMjl1WlM1amIyMHZOek0zWW1NNU9XRXRaV1E1TnkwMFkyUXlMVGxqWlRVdE0yWmxNbUZpTnpJMk1HRTFMMkZ6SWl3aWFuUnBJam9pTVRkbU1URXhObUl0TWprME1pMDBNbVZoTFRoak1UVXRNMk15TmpreVpHSTFaVEZpSWl3aWFXRjBJam94TnpJek1EVXhNekV6TENKbGVIQWlPakUzTWpNd05UUTVNVE1zSW1GMVpDSTZXeUpvZEhSd2N6b3ZMMkZ3YVM1d2FXNW5iMjVsTG1OdmJTSmRMQ0psYm5ZaU9pSTNNemRpWXprNVlTMWxaRGszTFRSalpESXRPV05sTlMwelptVXlZV0kzTWpZd1lUVWlMQ0p2Y21jaU9pSm1ORGs1WkRobU1pMDRZMlkxTFRSbU1UZ3RPV1JpTlMwNE16WmhNemhpTnpZMVpUWWlmUS5VeURMbm1TYVN1b1RNbzBvNEtjNnlmUnpzWVNqMHd0bkVxSGt2MzUxVGx5OTlzaDBMRWxhYW1IbFJPWF9nMy1tSWtXVVZQT016WGNSemhzODFTSGhHVHl0ejBEQkhmU3lkdGFucnVrWGlsN2l5aFJ0cFJxRUY5RVdHT1JWUzdFMndvQnYwU3dJaFJta2xEWXR1bDRIb2lMN1JGa1ZINmNTeGFJRld3b2tLUTRzX1VNYTF4bXFXU21xVFNSYlNTZXBUVjdqbzZSNEhKZ1ZnTllEZDY4WVoyLWxHRzVKajJmenFhY1c0N0JDVnhPeENxTVNRT1hjbE5hLU9ZMFd1RTBPSXd2aXZNM3JmcGptX2M1TXIxcE5xM1FvVm5NNktSckNDRmlIZElEX1AzSlRnaVIxbUdlbEVPM1JTYUNTT2VvRmdOZTRxY3E3R0JZYXJSMWhZZjBQUFEK"
    content_base64sha256 = "P67kxaUNhjcW1n4KJJJonkvIHY6eU4QM37xrAXpFT0E="
    content_base64sha512 = "skR1ueOyerm5cI10RhnhK2xcAwM6WXzLb1tsVvVNEkwj4JmVImlFv/wuMQR58G7tHh5KfczXySw4iGEGqk1VHw=="
    content_md5          = "8e1f97c677060c3a668e4b4d3704b7b0"
    content_sha1         = "d314a632acce086bd9e328ce95effa9a3297eb69"
    content_sha256       = "3faee4c5a50d863716d67e0a2492689e4bc81d8e9e53840cdfbc6b017a454f41"
    content_sha512       = "b24475b9e3b27ab9b9708d744619e12b6c5c03033a597ccb6f5b6c56f54d124c23e09995226945bffc2e310479f06eed1e1e4a7dccd7c92c38886106aa4d551f"
    filename             = "./token.json"
    id                   = "d314a632acce086bd9e328ce95effa9a3297eb69"
}
```
