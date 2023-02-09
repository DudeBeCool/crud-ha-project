[crudservers]
%{ for index, hostname in hostnames ~}
    ${hostname} ansible_host=${ansible_hosts[index]}  
%{ endfor ~}

[crudservers:vars]
    db_url= postgresql://${username}:${password}@${db_public_ip}
    container_image=${ecr_image_endpoint}
    ansible_user=ubuntu
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
