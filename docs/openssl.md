## Generate a self-signed site certificate

1. Generate a root key
```bash
openssl genrsa -out "root-ca.key" 4096
```

2. Generate a CSR using the rook key
```bash
openssl req \
  -new -key "root-ca.key" \
  -out "root-ca.csr" -sha256 \
  -subj 'CN=My CA'
```

3. Configure the root CA
Create a new file called `root-ca.cnf` and paste the following contents into it.
This constrains the root CA to signing leaf certificates and not intermediate CAs.
```conf
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
```

4. Sign the certificate
```bash
openssl x509 -req -days 365 \
  -in "root-ca.csr" \
  -signkey "root-ca.key" -sha256 \
  -out "root-ca.crt" \
  -extfile "root-ca.cnf" \
  -extensions root_ca
```

5. Generate the site key
```bash
openssl genrsa -out "site.key" 4096
```

6. Generate the site certificate and sign it with the site key
```bash
openssl req \
  -new -key "site.key" \
  -out "site.csr" -sha256 \
  -subj '/CN=localhost'
```

7. Configure the site certificate.
Create a new `site.conf` file. This constrains the site certificate so that it can only be used to authenticate a server and can't be used to sign certificates
```conf
[server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:localhost, IP:127.0.0.1
subjectKeyIdentifier=hash
```

8. Sign the site certificate
```bash
openssl x509 -req -days 365 \
  -in "site.csr" -sha256 \
  -CA "root-ca.crt" \
  -CAkey "root-ca.key" \ 
  -CAcreateserial \
  -out "site.crt" \
  -extfile "site.cnf" \
  -extensions server
```

```bash
openssl req -x509 \
  -newkey rsa:4096 -sha256 -days 3650 \
  -nodes -keyout example.com.key \
  -out example.com.crt \
  -subj "/CN=example.com" \
  -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"
  ```

  ```bash
  openssl req -x509 \
  -newkey rsa:4096 \
  -keyout key.pem \
  -out cert.pem -sha256 -days 3650 \
  -nodes \
  -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
  ```
