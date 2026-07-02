# How to encypt secrets

- create a file called key-name.yaml.plain

- add this line:
```text
key-name: password
```

- run the commands: 

``` bash
$pub = 'pub key'
$tmp = Join-Path $env:TEMP 'server-ssh.pub'
Set-Content -Path $tmp -Value $pub -NoNewline -Encoding ascii
ssh-to-age -i $tmp
```

- then run the commands:

``` bash
.\sops-v3.13.2.amd64.exe --encrypt --age server-age ./secrets/key-name.plain.yaml > ./secrets/key-name.yaml
```

- for ACME DNS-01 with Cloudflare, add `cloudflare-dns-api-token` to `secrets/nextcloud.yaml` as an encrypted string secret.
	- I've added a plaintext placeholder at `secrets/cloudflare-dns-api-token.plain.yaml` — put your API token there, then encrypt it with `sops` and merge or copy the resulting entry into `secrets/nextcloud.yaml` per the repository workflow.