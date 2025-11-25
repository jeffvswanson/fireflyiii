# Installing Firefly-III on Pop!-OS 24.04
As of: 21 November 2025  
My installation guide for installing Firefly III, https://firefly-iii.org/ based off the Self-managed Server documentation, https://docs.firefly-iii.org/how-to/firefly-iii/installation/self-managed/.


This will be a Linux, Nginx, PHP, and PostgreSQL (LEPP) stack.

## Linux
Using Pop!-OS 24.04 LTS Beta with Nvidia
https://system76.com/pop/pop-beta/

### Prepare the Operating System
```shell
sudo apt update 
sudo apt -y upgrade
```

## Nginx
### Installation
```shell
sudo apt install -y nginx
```

**Note:** If you want to install and use the nginx stable repository rather than the Ubuntu distribution repository see:  https://nginx.org/en/linux_packages.html#Ubuntu

To check the installation and that nginx is running:
```shell
ps -ax | grep nginx
```

Another way is to navigate to http://localhost.  
The result should be a page with, "**Welcome to nginx!**"

## PostgreSQL
### Installation
```shell
sudo apt install -y postgresql
```

**Note:** If you want to install and use the PostgreSQL Apt Repository rather than the Ubuntu distribution repository see:  https://www.postgresql.org/download/linux/ubuntu/

I chose to keep the entirety of the database in the `fireflyiii` directory, however, I am going to makes sure the data is not posted publicly with `gitignore`.
```shell
initdb -D ~/fireflyiii/pgsql/data
echo '/pgsql/**' >> .gitignore
```

If you get an error similar to this:
```shell
initdb -D ~/fireflyiii/pgsql/data
> initdb: command not found
```
It means postgresql and its client commands are not in the list of directories the operating system will search for executable files.  
This can be remedied by adding postgresql to the `PATH` variable.
```shell
export PATH=$PATH:/usr/lib/postgresql/postgresql_version/bin
```
or more permanently by adding the above line to `.bashrc`, `.zshrc`, etc.

I leave it up to the user to decide if they want their PostgreSQL databases for financial information on a separate PostgreSQL cluster.

### Configuration
#### Locale
1. Using a text editor open the PostgreSQL data dircetory created above.
1. I prefer using UTC for timezones, search for `timezone` and `log_timezone` and set it to `'UTC'`.
1. For some reason PostgreSQL created my database cluster with a mish-mash of localization settings from the United States and Great Britain.  
`lc_monetary = 'en_US.UTF-8'`  
was the only setting I chose to change outright.

#### Logging
Just in case I want to make sure the logs are also configured to output to the `fireflyiii/pgsql` directory to ensure log information is not pushed to github.
- `log_destination = 'jsonlog'`
- `logging_collector = on`
- `log_directory` = `log`
- Uncomment `log_filename`

## PHP
### Installation
```shell
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y php8.4 php8.4-{bcmath,cli,common,curl,fpm,imap,intl,gd,ldap,mbstring,pgsql,xml,zip}
```

Check the install with:
```shell
php -v
```

### Configuration
1. In your text editor of choice open `etc/php/8.4/fpm/php.ini` with permissions to write to the file.
1. Search for `memory_limit` and set it to `512M`.
1. I prefer using UTC for timezones, search for `date` and set it to `UTC` or your timezone of choice.