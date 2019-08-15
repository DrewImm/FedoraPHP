# FedoraDev
A shell script to install PHP on Fedora

## Download

Download the repo to a suitable download folder, e.g. `~/Downloads`
```shell
cd ~/Downloads
git clone https://github.com/DrewImm/FedoraPHP.git
```

## Install
```shell
su root
cd FedoraPHP && chmod 755 dev-install.sh
./dev-install.sh
```

## Set permissions
```shell
su root
cd /var/www
./permissions apache html
```

## Packages
### Package managers
- Composer

### Code utilities
- Sass
- Filezilla

### Web Dev
- Lamp Stack
  - PHP 7
  - Maria DB
- XDebug
- PHPUnit
