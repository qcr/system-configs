# System Configuration Tracking Tool
The *system_configs* tool is a series of scripts for managing and tracking of system configuration files. This allows reproducibility of systems, replication of similar systems via the template funcationality, and the traceability of system state configurations. Example files that are tracked may be:

- Network files relating to static IP's
- Network settings pertaining to ROS
- Executable scripts that are essential on said system

## How to Track/Untrack Files
- Run the following command to track a file. Currently only individual files are supported (wildcards are not supported but are being looked into):
```bash
# Enter the directory containing the file(s) to track
cd <required directory>

# Track the file (replace <FILE_NAME>) 
# You can specify the hostname to track against (omit "--hostname <HOSTNAME>" to use the hostname of the current machine)
sudo qcr system_configs track --hostname <HOSTNAME> <FILE_NAME>
```
- To untrack (unlink) run the following command(s)
```bash
# Enter the directory containing the file(s) to untrack
cd <required directory>

# Untrack the file (replace <FILE_NAME> and <HOSTNAME>). HOSTNAME, in this case, is what this file was originally tracked against. 
sudo qcr system_configs track --hostname <HOSTNAME> --unlink <FILE_NAME>
```

## Syncing Files 
Once tracked, these files can be synced up to a dedicated machine repository within a specified user or Github organisation. These repositories will have the following naming structure: *\<user-or-organisation\>/system-configs-\<NAME\>*; where *NAME* is the provided *hostname* arguments above. 

This allows for machine variants (i.e., *athena-rtos*) to also be tracked within the same repository. Using *athena-rtos* as an example, the repository structure will be *\<user-or-organisation\>/system-configs-athena/rtos*. Similarly, unlinked files can also be updated to their dedicated repositories via the same command. Overall, this means that any changes made to these files can be easily synced and maintained for the life of said system.

To sync up files, run the following:
```bash
# Specify who you are to git (if required)
# NOTE: don't specify global
sudo git config user.name 'ENTER NAME'
sudo git config user.email 'ENTER EMAIL'

# Run the sync command (any location)
# NOTE: specify the branch as master (NOT main)
# NOTE: change HOSTNAME to desired name (or omit to default to machine hostname)
sudo qcr system_configs sync --hostname <HOSTNAME> --branch master
```

## Creating/Installing an Existing Template

A pre-existing template can be created/installed onto a new machine of the same type. We can install common configuration files across other systems of the same type and then track them once configured specifically to their specific instance of that system type.

### How to install/create a configuration template
- To do a new install from a template, please do the following. To create a new template, follow the same instructions; this will create a machine repository if it does not already exist:
```bash
# replace MACHINE with template name (e.g. system-configs-panda)
# replace VARIANT with variant name (e.g. rtos)
sudo system_configs install --template <user-or-organisation>/system-configs-<MACHINE> --template-variant <VARIANT>
```
- To do a new install from an existing machine name (duplication/resetting):
```bash
# run the install command
sudo system_configs install 
```

### Considering updates required from a template install

When creating a template, it is important to understand what files might require additional setup for usability. For example:

- Updates to network.link files (located at */etc/systemd/network/*) with appropriate MAC addresses to suite your robot and its network infrastructure.

It is important that if you are to create a template configuration set you keep it as general as possible to avoid additional configuration, or stipulate any updates (such as the above) in the template configuration repository README.