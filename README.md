# System Configuration Tracking Tool
The *system_configs* tool is a series of scripts for managing and tracking of system configuration files. This allows reproducibility of systems, replication of similar systems via the template funcationality, and the traceability of system state configurations. Example files that are tracked may be:

- Network files relating to static IP's
- Network settings pertaining to ROS
- Executable scripts that are essential on said system

## Basic Usage

### How to Track/Untrack Files
- Run the following command to track a file. Currently only individual files are supported (wildcards are not supported but are being looked into):
```bash
# Enter the directory containing the file(s) to track
cd <required directory>

# Track the file (replace <FILES>) 
system-configs track <FILES>
```
- To untrack (unlink) run the following command(s)
```bash
# Enter the directory containing the file(s) to untrack
cd <required directory>

# Untrack the file (replace <FILE>). There is no unlink, there is restore and delete
system-configs track --unlink <FILE>
```

### Syncing Files 
Once tracked, these files can be synced up to a dedicated remote repository within a specified user or Github organisation. These repositories will have the following naming structure: *\<user-or-organisation\>/system-configs-\<NAME\>*; where *NAME* is the provided *hostname* arguments above. 

This allows for sub-components within a system (e.g., an Intel NUC running a RTOS for the main GPU computer) to also be tracked within the same repository. Using *athena-rtos* as an example, the repository structure will be *\<user-or-organisation\>/system-configs-athena/rtos*. Similarly, unlinked files can also be updated to their dedicated repositories via the same command. Overall, this means that any changes made to these files can be easily synced and maintained for the life of said system.

To sync up files, run the following:
```bash
# Run the sync command supplying your GitHub User Email, the GitHub User or Organisation that you wish to own the remote repository, and a GitHub Public Access Token (PAT) that has the ability to create repositories within the supplied GitHub Owner.
system-configs sync <github_user_email> --owner <github_owner> --pat <github_pat>

# You can also set user defaults so you don't need to supply the github owner and github_pat every time. Using the config command.
# Run the command again if the defaults need to be updated.
system-configs config --owner <github_owner> --pat <github_pat>
```

### Installing a Configuration

To install a system configuration, assuming the same hostname, use the install command.

```bash
system-configs install 
```

## Using Templates

A configuration template can be created allowing for the reproduction of similar system types.

### Creating a Configuration Template

Use the sync command to create a template from the currently tracked system configuration files.

```bash
# Use the sync command and supply a template name to create a local and remote repo. 
# The name will be prefixed with 'template-' to allow for easy identification of templates
system-configs sync --template <NAME>
```

Use the above command to update a template as well. It will add any files that exist within the tracked system configuration files and notify the user of any differences between files in the template and system configuration file.

When creating a template, it is important to understand what files might require additional setup for usability. For example:

- Files specifying specific MAC addresses.

It is important that if you are to create a template configuration set you keep it as general as possible to avoid additional configuration, or stipulate any updates (such as the above) in the template configuration repository README.

### Installing a Configuration Template

To install a configuration template use the install command with the template argument.

```bash
system-configs install --template <NAME>
```

This will clone the template configuration files, and create a local and remote repository for tracking this specific system's configuration.