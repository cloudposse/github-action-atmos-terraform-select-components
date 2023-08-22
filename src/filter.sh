#!/bin/bash

set -ex

JQ_QUERY=${JQ_QUERY:-'to_entries[] | .key as $parent | .value.components.terraform | to_entries[] | select(.value.settings.github.actions_enabled // false) | [$parent, .key] | join(",")'}

atmos describe stacks --format json --file stacks.json
[ "$DEBUG" == "true" ] && cat stacks.json

jq -r "$JQ_QUERY" stacks.json > components.csv
[ "$DEBUG" == "true" ] && cat components.csv

echo -n "" > enriched_components.csv
while IFS=',' read -r stack component
do
    component_path=$(atmos describe component $component -s $stack --format json | jq -rc '.. | select(.component_info)? | .component_info.component_path')
    echo "$stack,$component,$component_path" >> enriched_components.csv
done < components.csv

[ "$DEBUG" == "true" ] && cat enriched_components.csv

echo -n '[' > components.json
while IFS=',' read -r stack component component_path; do
    stack_slug="$stack-$component"
    printf '{"stack": "%s", "component": "%s", "stack_slug": "%s", "component_path": "%s"},' "$stack" "$component" "$stack_slug" "$component_path" >> components.json
done < enriched_components.csv
sed -i.bak '$ s/,$//' components.json   # Removing the last comma and appending closing brackets
echo -n ']' >> components.json

[ "$DEBUG" == "true" ] && cat components.json

components=$(jq -c < components.json)
echo -n "$components" > components.json
[ "$DEBUG" == "true" ] && echo "Selected components: $components"
