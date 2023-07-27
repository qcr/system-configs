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
Once tracked, these files can be synced up to a dedicated remote repository within a specified user or Github organisation. These repositories will have the following naming structure: *\<user-or-organisation\>/system-configs-\<system-name\>*; where *system-name* is the hostname of the machine up until the first hyphen. A machine's hostname after the first hypen, is considered to be the *component-name* and identifies a component within the system. If the machine's hostname doesn't have a hyphen, the component name defaults to *main*.

This separation of the hostname after the first hyphen, allows for components within a system to be tracked within the same repository. For example, if a system was comprised of a main GPU machine with the hostname *athena*, and an Intel NUC running an RTOS with the hostname *athena-rtos*. The tracked files for *athena* will be stored at *\<user-or-organisation\>/system-configs-athena/main/default* (as the hostname doesn't contain a hyphen). The tracked files for *athena-rtos* will be stored at *\<user-or-organisation\>/system-configs-athena/rtos/default* (rtos as it is the portion contained after the first hyphen).

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

This command will copy the files in the component machine's directory to the system. Remember, the component is based on the machine's hostname. Additionally, as part of the installation process, the tool will attempt to run any executable scripts contained within an install directory within the components folder. For example, building on the *athena* and *athena-rtos* from the earlier sync example:

If the above command was run on a machine called *athena*. It would
1. Clone the remote stored at *https://github.com/<github_owner>/athena*;
2. Install the files stored in *https://github.com/<github_owner>/athena/main/default* to the required system locations; and
3. Run any executable scripts stored in *https://github.com/<github_owner>/athena/main/default/install*.

If the above command was run on a machine called *athena-rtos*. It would
1. Clone the remote stored at *https://github.com/<github_owner>/athena*;
2. Install the files stored in *https://github.com/<github_owner>/athena/rtos/default* to the required system locations; and
3. Run any executable scripts stored in *https://github.com/<github_owner>/athena/rtos/default/install*.

## Variants

You may have noticed in the example above the inclusion of a *default* folder. For example, in:

- *https://github.com/<github_owner>/athena/main/default*; and
- *https://github.com/<github_owner>/athena/rtos/default*

The tool also allows what is known as variants. A variant occurs when a system has competing requirements within a file. For example, a file may need to specify a different configuration depending if it is been used for Robot A or Robot B. This is where variants come in.

**Note**: The variant feature is limited in its utility. Further development is required to do things such as easily swapping between variants.


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


## Order of Operations

### Sync
The order of operations when syncing for a machine:

1. Create a remote machine repo, if required
2. Initialise the local machine repo, if required
3. Pull down the latest from the remote machine repo
4. Add, commit, and push to the remote machine repo

The order of operations when syncing for a template:

1. Create a remote template repo, if required
2. Initialise the local template repoe, if required
3. Copy files from the local machine repo to the local template repo
    - only files that don't already exist in the template will be copied
    - for all files that already exist, it will report if any files differ
5. Add, commit, and push to the remote template repo

### Installation
The order of operations when installing are:

1. Check remote and local repository for this machine exist, create if required
2. Get the remote and local into the same state
3. Clone, or pull, the latest template repo (if installing from a template)
4. Copy any files from the local template to the local machine repo
    - will only copy files that don't exist in the local machine repo
    - any files that already exist (based on filepath) will be checked for differences, and files that differ will be reported
5. Commit local machine repository to the remote
6. Install files from local repo to the machine
7. Run any installation scripts for the machine
