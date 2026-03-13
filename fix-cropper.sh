#!/bin/bash

# Fix for cropperjs CSS import issue in @churchapps/apphelper
# Run this script after npm install if you encounter cropper.css errors

echo "Fixing cropperjs CSS import issue..."

# Create the dist directory if it doesn't exist
mkdir -p node_modules/@churchapps/apphelper/node_modules/cropperjs/dist/

# Copy the CSS file from our version to the apphelper's version
if [ -f "node_modules/cropperjs/dist/cropper.css" ]; then
    cp node_modules/cropperjs/dist/cropper.css node_modules/@churchapps/apphelper/node_modules/cropperjs/dist/cropper.css
    echo "✅ Copied cropper.css file"
else
    echo "❌ Could not find cropper.css in node_modules/cropperjs/dist/"
    exit 1
fi

# Add the CSS export to the package.json if it's not already there
PACKAGE_JSON="node_modules/@churchapps/apphelper/node_modules/cropperjs/package.json"
if [ -f "$PACKAGE_JSON" ]; then
    if ! grep -q '"./dist/cropper.css"' "$PACKAGE_JSON"; then
        # Add the CSS export to the exports section
        sed -i 's|"exports": {|"exports": {\
    "./dist/cropper.css": "./dist/cropper.css",|' "$PACKAGE_JSON" 2>/dev/null || {
            echo "⚠️  Could not automatically update package.json exports"
            echo "   You may need to manually add: \"./dist/cropper.css\": \"./dist/cropper.css\""
        }
        echo "✅ Updated package.json exports"
    else
        echo "✅ Package.json exports already updated"
    fi
else
    # cropperjs was hoisted to top-level node_modules; create a minimal package.json
    echo '{"name":"cropperjs","exports":{"./dist/cropper.css":"./dist/cropper.css"}}' > "$PACKAGE_JSON"
    echo "✅ Created package.json with CSS export (cropperjs was hoisted)"
fi

echo "🎉 Cropper fix applied successfully!"