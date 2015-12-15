#/bin/sh

set -x	

# Install curl if not already installed 

which curl >/dev/null 2>&1

if  [ $? != 0 ]; then

  yum install -y curl >/dev/null 2>&1

fi

# Install wget if not already installed 

which wget >/dev/null 2>&1

if  [ $? != 0 ]; then

  yum install -y wget >/dev/null 2>&1

fi

# Install git if not already installed 

which git >/dev/null 2>&1

if  [ $? != 0 ]; then

  yum install -y git >/dev/null 2>&1

fi

# Install Epel-release if not already installed

yum install -y epel-release >/dev/null 2>&1


# Install python-pip  if not already installed

which python-pip >/dev/null 2>&1

if  [ $? != 0 ]; then

yum install -y python-pip >/dev/null 2>&1

fi

# Install boto3

pip install boto3 >/dev/null 2>&1

#change to tmp and download aws-snapshot-tool

cd /tmp

git clone https://github.com/evannuil/aws-snapshot-tool.git >/dev/null 2>&1

# Change dir to aws-snapshot-tool

cd aws-snapshot-tool

# create and push the contents given below into config.py
# Add accesskey,secretkey, region info, tagname of volume

touch config.py
 
echo " config = {

    # AWS credentials for the IAM user (alternatively can be set up as environment variables)
    'aws_access_key': 'xxxxxxxx',
    'aws_secret_key': 'xxxxxxxxxxxx',

    # EC2 info about your server's region
    'ec2_region_name': 'us-east-1',
    'ec2_region_endpoint': 'ec2.us-east-1.amazonaws.com',

    # Tag of the EBS volume you want to take the snapshots of
    'tag_name': '$Tagname',
    'tag_value': 'True',

    # Number of snapshots to keep (the older ones are going to be deleted,
    # since they cost money).
    'keep_day': 5,
    'keep_week': 5,
    'keep_month': 11,

    # Path to the log for this script
    'log_file': '/tmp/makesnapshots.log',

    # ARN of the SNS topic (optional)
    #'arn': 'xxxxxxxxxx',

    # Proxy config (optional)
    #'proxyHost': '10.100.x.y',
    #'proxyPort': '8080'
} " > config.py

# Aws environment configure 

echo " Enter AWS Access Key ID [None]:AWS Secret Access Key [None]: Default region name [None]: press enter for default output format "

aws configure

# Aws Describe Tags

echo " Descibe Tags"

aws ec2 describe-tags > describe-tags

# Aws descibe volumes

echo " Descibe volumes "

aws ec2 describe-volumes > describe-volumes

#execute python script

chmod +x makesnapshots.py

python makesnapshots.py day
