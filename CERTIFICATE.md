To get an official certificate, you need to have a DNS. The easies way to do so is with Dynamic DNS

## 1. Setting up Dynamic DNS

The IP address of your JupyterHub server will change if you suspend or stop the server, so a dynamic DNS is needed.

Step 1. Set up a Dynamic DNS synthetic record

Step 2. Sep up and configure a client program in your JupyterHub server, using the username and password generated in Step 1.  
DDclient is suggested to used. You need to install ddclient in your server:  
```shell
sudo apt install ddclient
```
Once the installation completes, a configuration wizard will automatically start. You can type anything randomly, because the configuration file will be edited manually.  

Open the configuration file after the wizard completes:
```shell
sudo nano /etc/ddclient.conf
```

Replace the content with the following: 
```shell
# /etc/ddclient.conf
protocol=dyndns2
use=web
server=domains.google.com
ssl=yes
login=generated_username
password=generated_password
your_resource.your_domain.tld
```

Remember to replace with your username and password, and domain name. 

Run the following code to detect your current IP address and update your DNS server:
```shell
sudo ddclient
```
You need to run ddclient each time when the IP address is updated, or you can configure it to check and update IP periodically.  

See more details on [Dynamic DNS](https://support.google.com/domains/answer/6147083?hl=en)


## 2. Enabling the official HTTPS certificate

Follow the commands on [Automatic HTTPS with Let’s Encrypt](http://tljh.jupyter.org/en/latest/howto/admin/https.html#automatic-https-with-let-s-encrypt)
(which will undo some of the ones run by the `post_makefile_script` which used a self-signed certificate)
