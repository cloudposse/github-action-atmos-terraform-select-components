
<!-- markdownlint-disable -->
# github-action-atmos-terraform-select-components

 [![Latest Release](https://img.shields.io/github/release/cloudposse/github-action-atmos-terraform-select-components.svg)](https://github.com/cloudposse/github-action-atmos-terraform-select-components/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

GitHub Action that outputs list of Atmos components by jq query

---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.


It's 100% Open Source and licensed under the [APACHE2](LICENSE).












## Introduction

GitHub Action that outputs list of Atmos components by jq query.

For example following query will fetch components that have in settings set `github.actions_enabled: true`:

```
.value.settings.github.actions_enabled // false
```

Output of this action is a list of basic component information. For example:

```json
[
  {
  "stack": "plat-ue2-sandbox",
  "component": "test-component-01",
  "stack_slug": "plat-ue2-sandbox-test-component-01",
  "component_path": "components/terraform/s3-bucket"
  }
]
```



## Usage



### Config

The action expects the atmos gitops configuration file to be present in the repository in `./.github/config/atmos-gitops.yaml`.
The config should have the following structure:

```yaml
  atmos-version: 1.45.3
  atmos-config-path: ./rootfs/usr/local/etc/atmos/
  terraform-state-bucket: cptest-core-ue2-auto-gitops
  terraform-state-table: cptest-core-ue2-auto-gitops
  terraform-state-role: arn:aws:iam::xxxxxxxxxxxx:role/cptest-core-ue2-auto-gitops-gha
  terraform-plan-role: arn:aws:iam::yyyyyyyyyyyy:role/cptest-core-gbl-identity-gitops
  terraform-apply-role: arn:aws:iam::yyyyyyyyyyyy:role/cptest-core-gbl-identity-gitops
  terraform-version: 1.5.2
  aws-region: us-east-2
  enable-infracost: false
  sort-by: .stack_slug
  group-by: .stack_slug | split("-") | [.[0], .[2]] | join("-")  
```  

> [!IMPORTANT]
> **Please note!** the `terraform-state-*` parameters refer to the S3 Bucket and corresponding meta storage DynamoDB table used to store the Terraform Plan files, and not the "Terraform State". These parameters will be renamed in a subsequent release.

### GitHub Actions Workflow Example

In following GitHub workflow example first job will filter components that have settings `github.actions_enabled: true` and then in following job `stack_slug` will be printed to stdout.

```yaml
  jobs:
    selected-components:
      runs-on: ubuntu-latest
      name: Select Components
      outputs:
        matrix: ${{ steps.components.outputs.matrix }}
      steps:
        - name: Selected Components
          id: components
          uses: cloudposse/github-action-atmos-terraform-select-components@v0
          with:
            atmos-config-path: "${{ github.workspace }}/rootfs/usr/local/etc/atmos/"
            jq-query: 'to_entries[] | .key as $parent | .value.components.terraform | to_entries[] | select(.value.settings.github.actions_enabled // false) | [$parent, .key] | join(",")'

    print-stack-slug:
      runs-on: ubuntu-latest
      needs:
        - selected-components
      if: ${{ needs.selected-components.outputs.matrix != '{"include":[]}' }}
      strategy:
        matrix: ${{ fromJson(needs.selected-components.outputs.matrix) }}
      name: ${{ matrix.stack_slug }}
      steps:
        - name: echo 
          run:
            echo "${{ matrix.stack_slug }}"
```

### Migrating from `v0` to `v1`

1. `v1` replaces the `jq-query` input parameter with a new parameter called `selected-filter` to simplify the query for end-users.
  Now you need to specify only the part used inside of the `select(...)` function of the `jq-query`.  

2.`v1` moves most of the `inputs` to the Atmos GitOps config path `./.github/config/atmos-gitops.yaml`. Simply create this file, transfer your settings to it, then remove the corresponding arguments from your invocations of the `cloudposse/github-action-atmos-terraform-select-components` action.

|         name             |
|--------------------------|
| `atmos-version`          |
| `atmos-config-path`      |


If you want the same behavior in `v2` as in `v1` you should create config `./.github/config/atmos-gitops.yaml` with the same variables as in `v0` inputs.

```yaml
  - name: Selected Components
    id: components
    uses: cloudposse/github-action-atmos-terraform-select-components@v1
    with:
      atmos-gitops-config-path: ./.github/config/atmos-gitops.yaml
      select-filter: '.settings.github.actions_enabled // false'
```

Which would produce the same behavior as in `v2`, doing this:

```yaml
  - name: Selected Components
    id: components
    uses: cloudposse/github-action-atmos-terraform-select-components@v0
    with:
      atmos-config-path: "${{ github.workspace }}/rootfs/usr/local/etc/atmos/"
      jq-query: 'to_entries[] | .key as $parent | .value.components.terraform | to_entries[] | select(.value.settings.github.actions_enabled // false) | [$parent, .key] | join(",")'
```

Please note that the `atmos-gitops-config-path` is not the same file as the `atmos-config-path`.









## Related Projects

Check out these related projects.



## References

For additional context, refer to some of these links.

- [github-action-atmos-terraform-drift-detection](https://github.com/cloudposse/github-action-atmos-terraform-drift-detection) - Companion GitHub Action for drift detection
- [github-action-atmos-terraform-drift-remediation](https://github.com/cloudposse/github-action-atmos-terraform-drift-remediation) - Companion GitHub Action for drift remediation
- [github-actions-workflows](https://github.com/cloudposse/github-actions-workflows) - Reusable workflows for different types of projects
- [example-github-action-release-workflow](https://github.com/cloudposse/example-github-action-release-workflow) - Example application with complicated release workflow


## ✨ Contributing

This project is under active development, and we encourage contributions from our community. 
Many thanks to our outstanding contributors:

<a href="https://github.com/cloudposse/github-action-atmos-terraform-select-components/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudposse/github-action-atmos-terraform-select-components&max=24" />
</a>

### 🐛 Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/github-action-atmos-terraform-select-components/issues) to report any bugs or file feature requests.

### 💻 Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

### 🌎 Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

### 📰 Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

### 📆 Office Hours <img src="https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png" align="right" />

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

## About 

This project is maintained and funded by [Cloud Posse, LLC][website]. 
<a href="https://cpco.io/homepage"><img src="https://cloudposse.com/logo-300x69.svg" align="right" /></a>

We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]
## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```

## Trademarks

All other trademarks referenced herein are the property of their respective owners.
---
Copyright © 2017-2023 [Cloud Posse, LLC](https://cpco.io/copyright)
[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]
<!-- markdownlint-disable -->
  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=slack
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=twitter
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=newsletter
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/github-action-atmos-terraform-select-components&utm_content=readme_commercial_support_link
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/github-action-atmos-terraform-select-components?pixel&cs=github&cm=readme&an=github-action-atmos-terraform-select-components
<!-- markdownlint-restore -->
