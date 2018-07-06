#!/bin/bash
#http://api.vk.com/blank.html#access_token=А?Хуй на!&expires_in=0&user_id=177468929
 
# Input params from zabbix
vk_user_id=$1
vk_subject=$2
vk_message=$3
vk_api_version=5.80
 
vk_full_message="[$vk_subject]%0A$vk_message%0A[/$vk_subject]"
 
# Access token from vk app
vk_access_token="токен_авторизации"
 
# URL for VK.API method
vk_api_method_url="https://api.vk.com/method/messages.send"
 
# Request
curl -d "access_token=$vk_access_token&user_id=$vk_user_id&message=$vk_full_message&v=$vk_api_version" $vk_api_method_url
