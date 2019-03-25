# Alias Create
This script can create a Drush alias with a simple command

## Getting Started
This instruction will give you information on how to execute the script

### Prerequisites
Machine token is set in Pantheon account settings and has ran with the following command:
```
$ terminus auth:login [--machine-token [MACHINE-TOKEN]] [--email [EMAIL]]
```


### Running the command
One argument is needed for this script: 
* Site: (sitename.environment)
Run the command in the following format:
```
bash alias_create.sh <sitename>.<environment>
```

### How it works
* The script will make terminus commands to retrieve the information needed for the Drush alias. 
* It creates the alias and input the retrieved information. 
* It moves the alias file under ~/.drush/aliases directory
* If ~/.drush/aliases does not exist, it will get created before the alias is moved. 