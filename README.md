# Custom Gitleaks Image Builder

This repository contains a GitLab CI/CD pipeline that builds a custom Gitleaks image with your own security rules and configurations, then pushes it to your local registry for use in other CI/CD pipelines.

## Features

- 🔨 **Custom Image Building**: Builds gitleaks with your custom security rules
- 📦 **Local Registry Integration**: Makes custom gitleaks available in your private registry
- 🏷️ **Version Management**: Maintains versioned tag (v8.28.0)
- 📢 **Notifications**: Sends notifications when images are updated
- 🧹 **Cleanup**: Automatically removes local images after pushing
- 🔒 **Custom Rules**: Easy to add and modify security detection patterns

## Quick Start

### Using the Image in GitLab CI

Once the image is available in your local registry, you can use it in other projects with docker run:

```yaml
# .gitlab-ci.yml
gitleaks-scan:
  stage: security
  script:
    - docker run --rm -v $CI_PROJECT_DIR:/app 192.168.0.2:5050/security/gitleaks:v8.28.0 gitleaks detect --source /app --report-format json --report-path /app/gitleaks-report.json
  artifacts:
    paths:
      - gitleaks-report.json
    expire_in: 1 week
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

### Manual Image Build

If you need to manually build the custom image:

```bash
# Build the custom image
docker build -t 192.168.0.2:8090/security/gitleaks:v8.28.0 .

# Push to your registry
docker push 192.168.0.2:8090/security/gitleaks:v8.28.0
```

## CI/CD Pipeline

The GitLab CI pipeline includes:

1. **Docker Stage**: 
   - Builds a custom gitleaks image using the Dockerfile
   - Includes your custom security rules from `.gitleaks.toml`
   - Pushes the custom image to your local registry
2. **Notify Stage**: Sends notifications via Nextcloud Talk when build succeeds

### Pipeline Features

- 🔨 **Automated Custom Build**: Builds custom image with your rules on main branch and tags
- 📢 **Notifications**: Sends detailed notifications via Nextcloud Talk
- 🏷️ **Version Management**: Maintains latest tag
- 🧹 **Cleanup**: Automatically removes local images after pushing
- 🔒 **Custom Rules**: Uses your `.gitleaks.toml` configuration

### Pipeline Variables

Set these variables in your GitLab project settings (see `GITLAB_CI_VARIABLES.md` for details):

#### Registry Authentication
- `CI_REGISTRY_USER`: Username for your local registry
- `CI_REGISTRY_PASSWORD`: Password for your local registry

#### Nextcloud Notifications
- `NEXCLOUD_USERNAME`: Nextcloud username for API authentication
- `NEXCLOUD_PASSWORD`: Nextcloud password for API authentication
- `NEXCLOUD_URL`: Base URL of your Nextcloud instance
- `NEXCLOUD_CONVERSATION_TOKEN`: Token for the specific Nextcloud Talk conversation

## Configuration

### Pipeline Variables

The pipeline uses these variables to build and push images:
- `GITLEAKS_VERSION`: Version of gitleaks to build (currently v8.28.0)
- `SOURCE_IMAGE`: Docker Hub base image (zricethezav/gitleaks:v8.28.0)
- `TARGET_IMAGE`: Local registry target image (v8.28.0 tag)

### Registry Integration

The pipeline automatically:
- Authenticates with your local registry using `CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD`
- Builds a custom gitleaks image using the Dockerfile
- Includes your custom security rules from `.gitleaks.toml`
- Pushes the custom image to your local registry

### Custom Configuration

To add more security rules:
1. Edit the `.gitleaks.toml` file with your custom patterns
2. Commit and push your changes
3. The pipeline will automatically build a new custom image with your rules
4. The new image will be available in your local registry

**Example**: Add a new rule to `.gitleaks.toml`:
```toml
[[rules]]
id = "custom-aws-key"
description = "AWS Access Key pattern"
regex = '''AKIA[0-9A-Z]{16}'''
tags = ["key", "aws"]
confidence = "high"
```

## Getting started

To make it easy for you to get started with GitLab, here's a list of recommended next steps.

Already a pro? Just edit this README.md and make it your own. Want to make it easy? [Use the template at the bottom](#editing-this-readme)!

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin http://192.168.0.2:8090/security/gitleaks.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](http://192.168.0.2:8090/security/gitleaks/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
