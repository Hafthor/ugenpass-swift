# ugenpass-swift
Cryptographically derived passwords.

Designed to be:

* strong - uses PBKDF2
* secure - no networking or storage
* short - <60 lines of Swift
* simple - only uses pbkdf2 crypto
* understandable - see algorithm below

Algorithm is:

`hash[hash[hash[password]+domain]+password]` where hash is saltless pbkdf2 with 65536 rounds of sha256, then treating the result as a 32-byte big-endian unsigned integer and dividing the result, using the remainder to select characters from template, starting left to right.

Usage:

```
UGetPass.generate(password:"password", domain:"example.com")
```

returns
`dc2Cs!HL6WZ!mY3Pm(YI8If`

ugenpass function parameters:

* password - string
* domain - string - normally just the base domain without www or similiar. Be sure to trim, normalize, lowercase before calling. EXAMPLE.COM is not the same as example.com

Default template has ~9.38E+32 combinations (~2^109)
