Translation_checksite for OpenStack I18N
========================================

Installation on Open Telekom Cloud:
-----------------------------------

```
    git clone https://github.com/eumel8/ansible-otc.git
    cp -r ansible-otc/roles .
    ansible-playbook tenant_create.yml -e "ecs_name=i18n" -e "ecs_user_data=$(base64 -w 0 user-data )"
```

hint: require OS_USERNAME, OS_PASSWORD, OS_PROJECT_NAME, OS_REGION_NAME,
OS_USER_DOMAIN_NAME, OS_AUTH_URL, OS_IDENTITY_API_VERSION,
OS_ENDPOINT_TYPE


Local installation:
-------------------

```
    ./install.sh
```

hint: with self-signed certificate
