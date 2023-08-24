<!-- markdownlint-disable -->

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| atmos-config-path | The path to the atmos.yaml file | atmos.yaml | false |
| atmos-version | The version of atmos to install if install-atmos is true | latest | false |
| debug | Enable action debug mode. Default: 'false' | false | false |
| default-branch | The default branch to use for the base ref. | ${{ github.event.repository.default\_branch }} | false |
| jq-query | jq query that will be used to select atmos components | N/A | true |
| jq-version | The version of jq to install if install-jq is true | 1.6 | false |
| terraform-version | The version of terraform to install if install-terraform is true | latest | false |


## Outputs

| Name | Description |
|------|-------------|
| has-selected-components | Whether there are selected components |
| matrix | Matrix for Selected GitOps components |
| selected-components | Selected GitOps components |
<!-- markdownlint-restore -->
