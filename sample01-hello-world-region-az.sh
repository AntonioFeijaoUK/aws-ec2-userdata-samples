#!/bin/bash
yum update -y

#amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2

yum install -y httpd

systemctl start httpd
systemctl enable httpd

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www

chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

PublicHostname=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
InstanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)


OUTPUT='/var/www/html/index.html'

cat <<EOF > ${OUTPUT}
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World! Site Title - AntonioCloud.com</title>
    <style>
        .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: gray;
            color: white;
            text-align: center;
        }
    </style>
</head>

<body>
    <h1>Hello World! By Antonioaws.com</h1>
    <h2>Powered by AWS PrivateLink >>> NLB >>> EC2 >>> Amazon Linux >>> apache/nginx </h2>
    <p>From instance with id of ..: ${InstanceID}</p>
    <p>with public address of ....: ${PublicHostname}</p>
    <p>that is in the Region-AZ ..: ${AZ}</p>

    <div class="footer">
        <p>
            <a href="https://www.antoniocloud.com/" target="_blank">www.antoniocloud.com</a>
        </p>
    </div>

</body>

</html>
EOF
