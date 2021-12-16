#!/bin/bash
yum update -y

#
# version 2021-12-16-0048
#
# mostly sourced from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
#


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


OUTPUT_FILE="/var/www/html/index.html"

cat <<EOF > ${OUTPUT_FILE}
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World! Sample test page By https://Antonio.Cloud</title>
    <style>
        .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: white;
            color: white;
            text-align: center;
        }
    </style>
</head>

<body>
    <h1>Hello World! Sample test page By https://Antonio.Cloud</h1>
    
    <h2 id="my-url"></h2>
    
    <p>From instance with id of ..: ${InstanceID}</p>
    <p>with public address of ....: ${PublicHostname}</p>
    <p>that is in the Region-AZ ..: ${AZ}</p>



    <div class="footer">
        <p>
            <a href="https://antonio.cloud/" target="_blank">https://antonio.cloud/</a>
        </p>
    </div>

    <script>
        document.getElementById("my-url").innerHTML = 
        "Welcome to " + window.location.href;
    </script>


</body>

</html>
EOF
