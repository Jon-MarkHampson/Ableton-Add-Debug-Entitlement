#!/bin/bash
# Simple Utility Script for allowing debug of hardened macOS apps.
# This is useful mostly for plug-in developers who want to continue developing without turning off SIP.
#
# Original script by talaviram:
# https://gist.github.com/talaviram/1f21e141a137744c89e81b58f73e23c3
#
# Modifications by [Your Name]:
# - Added steps to remove extended attributes to avoid codesign errors on macOS Sonoma.
# - Included the creation of entitlements plist if it does not exist.
#
# Please note:
# - Modern Logic (on M1/M2 Macs) uses `AUHostingService` which resides within the system and is not patchable, requiring SIP to be turned off.
# - Some hosts use separate plug-in scanning or sandboxing. If that's the case, it's required to patch those (if needed) and attach the debugger to them instead.
#
# If you see `operation not permitted`, make sure the calling process has Full Disk Access.
# For example, Terminal.app should be visible and have Full Disk Access under System Preferences -> Privacy & Security.

app_path=$1

if [ -z "$app_path" ];
then
    echo "You need to specify the app to re-codesign!"
    exit 0
fi

# Remove extended attributes (xattr) to avoid signing errors
echo "Removing extended attributes from the app..."
sudo xattr -rc "$app_path"

# This uses local codesign, so it'll be valid ONLY on the machine you've re-signed with.
entitlements_plist=/tmp/debug_entitlements.plist

echo "Grabbing entitlements from app..."
codesign -d --entitlements - "$app_path" --xml >> $entitlements_plist || { echo "Failed to get entitlements!"; exit 1; }

# Check if the entitlements file is empty, and if so, create a new one
if ! test -s $entitlements_plist ; then
    echo "No entitlements found, creating a new plist..."
    cat > $entitlements_plist << EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
</dict>
</plist>
EOT
fi

echo "Patch entitlements (if missing)..."
/usr/libexec/PlistBuddy -c "Add :com.apple.security.cs.disable-library-validation bool true" $entitlements_plist
/usr/libexec/PlistBuddy -c "Add :com.apple.security.cs.allow-unsigned-executable-memory bool true" $entitlements_plist
/usr/libexec/PlistBuddy -c "Add :com.apple.security.get-task-allow bool true" $entitlements_plist
# allow custom dyld for sanitizers...
/usr/libexec/PlistBuddy -c "Add :com.apple.security.cs.allow-dyld-environment-variables bool true" $entitlements_plist

echo "Re-applying entitlements (if missing)..."
codesign --force --options runtime --sign - --entitlements $entitlements_plist "$app_path" || { echo "codesign failed!"; exit 1; }

echo "Removing temporary plist..."
rm $entitlements_plist

echo "Re-signing and entitlements applied successfully!"
