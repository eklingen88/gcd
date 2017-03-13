## Installation
```
wget https://github.com/eklingen88/gcd/archive/master.tar.gz
tar -xvzf master.tar.gz
mkdir -p /opt/git-code-deploy
cp -r gcd-master/* /opt/git-code-deploy/
cd /opt/git-code-deploy
chmod +x -R *.sh
./install.sh
```

## Prerequisites
- Git
- Logrotate

## Notes
- Initializes git repository and configures cron
- Source directory must exist 
- Source directory must not contain a git repository

## Roadmap
- Uninstall script
- Directions for git install