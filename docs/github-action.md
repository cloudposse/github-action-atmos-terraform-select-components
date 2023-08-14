<!-- markdownlint-disable -->

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| atmos-config-path | The path to the atmos.yaml file | atmos.yaml | false |
| atmos-version | The version of atmos to install if install-atmos is true | latest | false |
| debug | Enable action debug mode. Default: 'false' | false | false |
| default-branch | The default branch to use for the base ref. | ${{ github.event.repository.default\_branch }} | false |
| install-atmos | Whether to install atmos | true | false |
| install-jq | Whether to install jq | false | false |
| install-terraform | Whether to install terraform | true | false |
| jq-force | Whether to force the installation of jq | true | false |
| jq-query | jq query that will be used to select atmos components | 'to\_entries[] \| .key as $parent \| .value.components.terraform \| to\_entries[] \| select(.value.settings.github.actions\_enabled // false) \| [$parent, .key] \| join(",")' | true |
| jq-version | The version of jq to install if install-jq is true | 1.6 | false |
| terraform-version | The version of terraform to install if install-terraform is true | latest | false |


## Outputs

| Name | Description |
|------|-------------|
| enabled-components | Enabled GitOps components |
| has-enabled-components | Whether there are enabled components |
| matrix | Matrix for Enabled GitOps components |
<!-- markdownlint-restore -->
