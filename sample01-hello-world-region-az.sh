#!/bin/bash
#
# author: Antonio Feijao UK (https://www.antoniofeijao.com/)
#
# 2023-07-26 - added support from IMDSv2 (based on AWS docs https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)
# 2023-07-26 - minor tweaks to the html and css
# 2021-12-16 - initial version 
#
# Main script sourced from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
#
# Webspage building code done by Antonio Feijao UK (https://www.antoniofeijao.com/)
#

echo "
To use this file with your EC2' user-data, simply add the below 2 lines into the ec2 user-data

#!/bin/bash
curl https://raw.githubusercontent.com/AntonioFeijaoUK/aws-ec2-userdata-samples/master/sample01-hello-world-region-az.sh | bash

"
yum update -y

yum install -y httpd

systemctl start httpd
systemctl enable httpd

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www

chmod 2775 /var/www

find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

## update to use token on IMDSv2
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

INSTANCE_INFO=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/dynamic/instance-identity/document)

INSTANCE_ID=$(printf "$INSTANCE_INFO" |  grep instanceId | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_AZ=$(printf "$INSTANCE_INFO" |  grep availabilityZone | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_TYPE=$(printf "$INSTANCE_INFO" |  grep instanceType | awk '{print $3}' | sed s/','//g | sed s/'"'//g)

INSTANCE_REGION=$(printf "$INSTANCE_INFO" |  grep region | awk '{print $3}' | sed s/','//g | sed s/'"'//g)


cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Hello World sample page created using EC2 userdata, by Antonio Feijao UK (https://www.antoniofeijao.com/)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta charset="UTF-8">
  <style>
    body {
      background: url("https://www.antoniofeijao.com/assets/images/philipp-katzenberger-iIJrUoeRoCQ-unsplash.jpg") no-repeat center center fixed;
      -webkit-background-size: cover;
      -moz-background-size: cover;
      -o-background-size: cover;
      background-size: cover;
      background-color: DarkSlateGrey;
      text-align: center;
      color: GhostWhite;
    }
    
    .centered {
      position: fixed;
      top: 50%;
      left: 50%;
      /* bring your own prefixes */
      transform: translate(-50%, -50%);
    }
    
    .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: GhostWhite;
            color: DarkSlateGrey;
            text-align: center;
    }
    
    table {
      font-family: arial, sans-serif;
      border-collapse: collapse;
      width: 50%;
      font-size: 1.875em;
    }
    
    td, th {
      border: 1px solid #dddddd;
      text-align: left;
      padding: 8px;
    }
  </style>
</head>
<body>
  <div class=centered>
    <h1>Hello World sample page created using EC2 userdata</h1>
    <h2>by Antonio Feijao UK</h2>
    
    <h3 id="my-url"></h3>

    <table>
      <tr>
        <td>Instance ID</td>
        <td><code> ${INSTANCE_ID} </code></td>
      </tr>
      <tr>
        <td>Instance Type</td>
        <td><code> ${INSTANCE_TYPE} </code></td>
      </tr>
      <tr>
        <td>Instance Region</td>
        <td><code> ${INSTANCE_REGION} </code></td>
      </tr>
      <tr>
        <td>Availability Zone</td>
        <td><code> ${INSTANCE_AZ} </code></td>
      </tr>
    </table>
  </div>

    <div class="footer">
        <p><a href="https://www.antoniofeijao.com/" target="_blank">https://www.antoniofeijao.com/</a></p>
    </div>

    <script>
        document.getElementById("my-url").innerHTML = 
        "Welcome to " + window.location.href;
    </script>

</body>
</html>
EOF
