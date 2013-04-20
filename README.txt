Non-interactive Diffie-Hellman Public Key Cryptography
A PKI tool with two components:
  skgu_pki: to generate certificates binding newly generated public/private key pairs to identities (Rabin scheme).
  skgu_nidh: to generate secret symmetric keys. Requires a label (established through external agreement), your private key, and the other party's public key.

Dylan Hutchison
CS 579 Crypto
Lab 2 due 5 May 2013
http://www.cs.stevens.edu/~nicolosi/classes/13sp-cs579/lab2/lab2.html

To run a test script, please execute:
  make
  make cleanall
  make dotest
A sample run of the test script is in the file "typescript".

pv_misc.c contains one added function taken from lab1 to write an armored version of a 
secret key to a file: write_skfile.

The rest of the lab is implemented as specified in skgu_nidh.c

