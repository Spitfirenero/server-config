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