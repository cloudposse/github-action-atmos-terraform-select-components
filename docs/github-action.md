<!-- markdownlint-disable -->

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|----------|
| atmos-config-path | The path to the atmos.yaml file | N/A | true |
| atmos-version | The version of atmos to install | >= 1.63.0 | false |
| debug | Enable action debug mode. Default: 'false' | false | false |
| head-ref | The head ref to checkout. If not provided, the head default branch is used. | ${{ github.sha }} | false |
| jq-version | The version of jq to install if install-jq is true | 1.6 | false |
| nested-matrices-count | Number of nested matrices that should be returned as the output (from 1 to 3) | 2 | false |
| select-filter | jq query that will be used to select atmos components | . | false |
| process-functions | Whether to process functions | true | false |


## Outputs

| Name | Description |
|------|-------------|
| has-selected-components | Whether there are selected components |
| matrix | The selected components as matrix structure suitable for extending matrix size workaround (see README) |
| selected-components | Selected GitOps components |
<!-- markdownlint-restore -->
