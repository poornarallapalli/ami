new_ami=`aws ec2 describe-images --owners '070407025785' --filters 'Name=name,Values=poorna*' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'`

echo "latest poorna ami is $new_ami"

aws ec2 describe-instances --filters  --query 'Reservations[*].Instances[*].[InstanceId]' --output text > instances_list

while IFS= read -r line
do
        
    aws ec2 describe-instances --filters Name=instance-id,Values=$line --query 'Reservations[*].Instances[*].[ImageId]' --output 'text' > image_id
    while IFS= read -r new_line
    do
        if [[ "$new_line" = "$new_ami" ]]
	    then
	        continue
        else
            echo "$line" >> final_list
	    fi
    done < "image_id"
        
done < "instances_list"

rm instances_list
rm image_id


new_rhel_ami=`aws ec2 describe-images --owners '070407025785' --filters 'Name=name,Values=rhel*' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'`

echo "latest rhel ami is $new_rhel_ami"

while IFS= read -r line
do
        
    aws ec2 describe-instances --filters Name=instance-id,Values=$line --query 'Reservations[*].Instances[*].[ImageId]' --output 'text' > image_id
    while IFS= read -r new_line
    do
        if [[ "$new_line" = "$new_rhel_ami" ]]
	    then
	        continue
        else
            echo "$new_line" >> new_final_list
            echo "Instance $line doesn't have the latest ami"
	    fi
    done < "image_id"
        
done < "final_list"

rm image_id
rm final_list











