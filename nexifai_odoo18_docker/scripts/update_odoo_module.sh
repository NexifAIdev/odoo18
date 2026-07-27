#!/bin/bash

# Script: update_odoo_module.sh
# Purpose: Update Odoo modules using a saved list or add new ones dynamically
# Author: Jasper-ready 😊

CONTAINER_NAME="odoo18-web"   # must match container_name in docker-compose.yaml
DB_NAME="nexifai_odoo18_testdb06"
MODULE_FILE="modules_to_update.txt"

# Ensure the module file exists
touch "$MODULE_FILE"

echo "🔧 Odoo Module Update Script"
echo "Select an option:"
echo "1) Update ALL modules"
echo "2) Update a module from saved list"
echo "3) Add a new module and update it"

read -rp "Enter your choice (1-3): " choice

if [[ "$choice" == "1" ]]; then
  MODULE_FLAG="all"

elif [[ "$choice" == "2" ]]; then
  echo "📦 Saved modules:"
  index=1
  declare -A module_map
  while IFS= read -r module; do
    if [[ -n "$module" ]]; then
      echo "$index) $module"
      module_map[$index]="$module"
      ((index++))
    fi
  done < "$MODULE_FILE"

  if [[ $index -eq 1 ]]; then
    echo "❌ No modules found in $MODULE_FILE. Please add one first."
    exit 1
  fi

  echo ""
  read -rp "Enter the number of the module to update: " selected_index
  MODULE_FLAG="${module_map[$selected_index]}"

  if [[ -z "$MODULE_FLAG" ]]; then
    echo "❌ Invalid selection. Exiting."
    exit 1
  fi

elif [[ "$choice" == "3" ]]; then
  read -rp "Enter the name of the new module to add and update: " new_module
  if grep -Fxq "$new_module" "$MODULE_FILE"; then
    echo "ℹ️ Module '$new_module' already exists in the list."
  else
    echo "$new_module" >> "$MODULE_FILE"
    echo "✅ Module '$new_module' added to $MODULE_FILE."
  fi
  MODULE_FLAG="$new_module"

else
  echo "❌ Invalid option. Exiting."
  exit 1
fi

echo "🔄 Updating module(s): $MODULE_FLAG ..."
docker exec -i "$CONTAINER_NAME" bash -c "odoo -c /etc/odoo/odoo.conf -d $DB_NAME -u $MODULE_FLAG --stop-after-init"

echo "✅ Module update completed. Restarting container..."
docker restart "$CONTAINER_NAME"
echo "✅ Container restarted. Done."
