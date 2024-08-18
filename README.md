# Ableton-Add-Debug-Entitlement

This script allows you to modify entitlements for hardened macOS applications to enable debugging without turning off System Integrity Protection (SIP). It’s particularly useful for plugin developers working on macOS.

## Credits

This script is based on an original script by [talaviram](https://gist.github.com/talaviram/1f21e141a137744c89e81b58f73e23c3). Some modifications made by Jon-Mark Hampson.

## Modifications
- Removal of extended attributes to prevent codesign errors on macOS Sonoma.
- Added functionality to create an entitlements plist if one does not already exist.

## How to Use

### Step 1: Download or Clone the Script

You can either download the script directly or clone the repository.

#### Option 1: Download

1. Click the "Code" button at the top of the repository page.
2. Select "Download ZIP".
3. Extract the ZIP file to a location of your choice (e.g., your Desktop).

#### Option 2: Clone

Alternatively, if you have Git installed, you can clone the repository:

git clone https://github.com/Jon-MarkHampson/Ableton-Add-Debug-Entitlement-Script.git

===========================================================

### Step 2: Make the Script Executable
Open Terminal:

Go to Applications > Utilities > Terminal.
Navigate to the Script Directory:

If you downloaded the script to your Desktop, run:
cd ~/Desktop

If you cloned the repository, navigate to the cloned directory:
cd /path/to/your/cloned/repository
Make the Script Executable:

Run the following command to make the script executable:
chmod +x ableton_add_debug_entitlement.sh

===========================================================


### Step 3: Run the Script
Run the Script with Administrative Privileges:

You need to provide the path to the application you want to re-codesign. For example, to re-codesign Ableton Live 12, run:

sudo ./ableton_add_debug_entitlement.sh "/Applications/Ableton Live 12 Suite.app" // you can replace with your version of Live when required

The sudo command is required because modifying system files and re-signing applications requires administrative privileges.

Script Execution:

The script will:
Remove extended attributes from the application.
Extract the current entitlements and modify them to allow debugging.
Re-sign the application with the modified entitlements.
Successful Execution:

===========================================================

If everything works correctly, you should see a message indicating that re-signing and entitlements were applied successfully.

===========================================================

Troubleshooting:

Operation Not Permitted: If you see this error, make sure the Terminal (or whatever application you're using to run the script) has Full Disk Access enabled. You can do this in System Preferences > Privacy & Security > Full Disk Access.

Application Marked as Damaged: If the application doesn't open after re-signing, you may need to re-download the application and try the process again, ensuring all steps are followed correctly.
