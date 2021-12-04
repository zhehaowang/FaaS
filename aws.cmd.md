```bash
$ aws configure
```

Re-associate another elastic ip
```bash
$ aws ec2 describe-addresses
$ aws ec2 release-address --allocation-id eipalloc-0f5f0b001f67a5392
$ aws ec2 allocate-address --domain vpc
$ aws ec2 associate-address --allocation-id eipalloc-0d35351c53679198e --instance-id i-0681a427b7e24266a
```