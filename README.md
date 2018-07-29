Translation_checksite for OpenStack I18N
========================================

Installation on Open Telekom Cloud:
-----------------------------------

```
    ansible-playbook tenant_create.yml -e "ecs_name=i18n" -e "ecs_user_data=$(base64 -w 0 user-data )"
```


Local installation:
-------------------

```
    ./install.sh
```

hint: with self-signed certificate
