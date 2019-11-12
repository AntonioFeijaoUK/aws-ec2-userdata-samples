# aws-ec2-userdata-samples
AWS EC2 userdata-samples

## DISCLAIMER USE AT OWN RISK

- USE AT OWN RISK, fell free to copy the script and change it for your needs.



## Sample userdata for ec2 and how to use it

In the userdata for the ec2, add the command `curl` and the link for the script you want to run folloed by pip `| bash` to execute the script. 


```
#!/bin/bash

cd /tmp/

curl https://raw.githubusercontent.com/AntonioFeijaoUK/aws-ec2-userdata-samples/master/sample01-hello-world-region-az.sh | bash
```

