# System Configuration Tracking Tool
The *system-configs* tool is a series of scripts for managing and tracking of system configuration files. This allows reproducibility of systems, replication of similar systems via the template funcationality, and the traceability of system state configurations. Example files that are tracked may be:

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


### Syncing Files 
Once tracked, these files can be synced up to a dedicated remote repository within a specified user or Github organisation. These repositories will have the following naming structure: *\<user-or-organisation\>/system-configs-\<NAME\>*; where *NAME* is the hostname of the machine up until the first hyphen. A machine's hostname after the first hypen is considered to specify a sub-component within the system. 

This separation of the hostname after the first hyphen, allows for sub-components within a system to be tracked within the same repository. For example, if a system was comprised of a main GPU machine with the hostname *athena*, and an Intel NUC running a RTOS with the hostname *athena-rtos*. The tracked files for *athena* will be stored at *\<user-or-organisation\>/system-configs-athena/default* (default as it is the main component within the system). The tracked files for *athena-rtos* will be stored at *\<user-or-organisation\>/system-configs-athena/rtos* (rtos as it is the portion contained after the first hyphen).

To sync up files, run the following:
```bash
# Run the sync command supplying your GitHub User Email, the GitHub User or Organisation that you wish to own the remote repository, and a GitHub Public Access Token (PAT) that has the ability to create repositories within the supplied GitHub Owner.
system-configs sync <github_user_email> --owner <github_owner> --pat <github_pat>

# You can also set user defaults so you don't need to supply the github owner and github_pat every time. Using the config command.
# Run the command again if the defaults need to be updated.
system-configs config --owner <github_owner> --pat <github_pat>
```

### Installing a Configuration

To install a system configuration stored on a remote repository, use the install command.

```bash
# This will install the repository stored at https://github.com/<github_owner>/<NAME>, where NAME is the hostname of the machine up until the first hyphen. 
system-configs install --owner <github_owner> 
```

This command will copy the files in the sub-component machine's directory to the system. Remember, the sub-component is based on the machine's hostname. Additionally, as part of the installation process, the tool will attempt to run any scripts contained within an install directory within the sub-components folder. For example, building on the *athena* and *athena-rtos* from the earlier sync example:

If the above command was run on a machine called *athena*. It would
1. Clone the remote stored at *https://github.com/<github_owner>/athena*;
2. Install the files stored in *https://github.com/<github_owner>/athena/default* to the required system locations; and
3. Run any executable scripts stored in *https://github.com/<github_owner>/athena/default/install*.

If the above command was run on a machine called *athena-rtos*. It would
1. Clone the remote stored at *https://github.com/<github_owner>/athena*;
2. Install the files stored in *https://github.com/<github_owner>/athena/rtos* to the required system locations; and
3. Run any executable scripts stored in *https://github.com/<github_owner>/athena/rtos/install*.


## Using Templates

A configuration template can be created allowing for the reproduction of similar system types.

### Creating a Configuration Template

Use the sync command to create a template from the currently tracked system configuration files.

```bash
# Use the sync command and supply a template name to create a local and remote repo. 
# The name will be prefixed with 'template-' to allow for easy identification of templates within the owner's github account
system-configs sync --template <NAME>
```

Use the above command to update a template as well. It will add any files that exist within the tracked system configuration files and notify the user of any differences between files in the template and system configuration file.

When creating a template, it is important to understand what files might require additional setup for usability. For example, any files containing instance specific information such as IP or MAC addresses.

It is important you keep template configurations as general as possible to avoid additional configuration, or stipulate any updates (such as changing IP or MAC addresses) in the template configuration repository README.

### Installing a Configuration Template

To install a configuration template use the install command with the template argument.

```bash
system-configs install --template <NAME>
```

This will clone the template configuration files, and create a local and remote repository for tracking this specific system's configuration. You can rerun this command on a system that is already tracking its own system configuration, and only files within the template that aren't already within the system configuration will be installed.