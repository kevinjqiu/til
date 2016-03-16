Account
=======

Create an account
-----------------

```
$ curl -XPOST -H"Content-Type: application/json" -H"PTS-LCP-Mode: account" -H"PTS-LCP-Base-URL: http://lcpenv:1143" http://lcpenv:1043/accounts/ -d'{"email": 
"kevin@points.com"}'                                                                                                                                                                  
{
  "accountCredentials": [
    {
      "links": {
        "self": {
          "href": "http://lcpenv:1143/accounts/2439ac04-c8da-479d-bbb2-322d729ee434/account-credentials/8885e0a1-6509-4b8d-897c-49ce7e1e7619"
        }
      },
      "macAlgorithm": "HMAC-SHA1",
      "macKey": "BeSMw2lr9OzKdqX-_xRv7UtWUpy268BmmS1cvmH3bEI",
      "macKeyIdentifier": "1a100b28e5404cd6ae6fe090d0ec4c9c"
    }
  ],
  "createdAt": "2016-03-16T18:37:11.744669Z",
  "email": "kevin@points.com",
  "links": {
    "friendly": {
      "href": "http://lcpenv:1143/accounts/kevin%40points.com"
    },
    "self": {
      "href": "http://lcpenv:1143/accounts/2439ac04-c8da-479d-bbb2-322d729ee434"
    }
  },
  "roles": [
    "appDeveloper"
  ],
  "timeZone": "America/Toronto",
  "type": "account",
  "updatedAt": "2016-03-16T18:37:11.744669Z"
}
```

Get account by email
---------------------

```
 $ curl -H"PTS-LCP-Mode: account" -H"PTS-LCP-Base-URL: http://10.0.3.20:1143" http://10.0.3.20:1043/accounts/kevin%40points.com
{
  "accountCredentials": [],
  "createdAt": "2016-03-16T18:37:11.744669Z",
  "email": "kevin@points.com",
  "links": {
    "friendly": {
      "href": "http://10.0.3.20:1143/accounts/kevin%40points.com"
    },
    "self": {
      "href": "http://10.0.3.20:1143/accounts/2439ac04-c8da-479d-bbb2-322d729ee434"
    }
  },
  "roles": [
    "appDeveloper"
  ],
  "timeZone": "America/Toronto",
  "type": "account",
  "updatedAt": "2016-03-16T18:37:11.744669Z"
}
```
