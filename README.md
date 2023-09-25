## Wrapper for openssl for quick creation of selfsigned certificates

This script will generate a certificate and a keyfile for you to use in test environments.
It will autofill some fields when it can, those are the fields in brackets.


Example:
h00chm@hardmode:~/Code/ssl$ ./selfsigned-gen.sh
Enter key filename [key.pem]:
Enter certificate filename [cert.pem]:
Enter country [SE]:
Enter State [NONE]:
Enter Location: test
Enter Company or Organization name: test
Enter Unit or Department [TEST]:
Enter contact email: not@yet.se
Enter hostname/ip: [hardmode]
Do you wish to add another IP/hostname aka (SAN)? (y/n): y
Enter additional hostname/ip : 192.168.1.192
Do you wish to add another IP/hostname aka (SAN)? (y/n): n
....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*................+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.+..+............+................+..+.......+...........+....+...........+.........+.+..+......+......+....+.....+.......+..+.......+......+.................+............................+.........+.....+..........+......+.....+..................+.+......+........+...................+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
