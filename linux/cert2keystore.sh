cat intermediate.pem root.pem > chain.pem
openssl pkcs12 -export -out bundle.pfx -inkey privkey.pem -in cert.pem -certfile chain.pem -password 428428
keytool -importkeystore -srckeystore bundle.pfx -srcstoretype pkcs12 -destkeystore agrotronic.keystore -deststoretype JKS
keytool -changealias -alias "1" -destalias "agrotronic" -keystore agrotronic.keystore
