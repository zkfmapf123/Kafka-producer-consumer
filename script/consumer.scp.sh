EXTERNAL_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=consumer" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

echo $EXTERNAL_IP
