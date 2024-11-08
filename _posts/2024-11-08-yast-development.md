---
layout: post
title:  YaST Development Update: Bug Fixes and Improvements
date:   2024-11-08 15:46:46 +0100
description: Time for another regular status update from the YaST team with news about YaST itself.
categories: yast development
permalink: blog/2024-11-08/yast-report-2022-2
tags:
- Distribution
- Factory
- Programming
- Systems Management
- YaST

---

It's time for another update on the ongoing development of YaST, your favorite system administration tool! Our team has been hard at work squashing bugs, improving features, and ensuring a smooth and efficient user experience. Here's a rundown of some of the recent changes:

**Enhanced Security and User Management**

  * **Addressing outdated configuration parameters:** We've removed outdated parameters from the YaST security module to prevent conflicts with `useradd`, `usermod`, and `userdel` commands on newer systems (Factory, Tumbleweed, Slowroll). This ensures compatibility and prevents unexpected errors when managing users ([yast-security](https://github.com/yast/yast-security/pull/160)).
  * **Robust blacklist parsing:** Improved the parsing of blacklisted modules in YaST to handle spaces around commas correctly, preventing issues when multiple modules are blacklisted ([pull request](https://github.com/yast/yast-installation/pull/1127)).

**Improved Installation and Configuration**

  * **iSCSI client enhancements:**  The iSCSI client now correctly handles auto-login and service activation during installation, ensuring a smoother setup process for iSCSI-based systems ([pull request](https://github.com/yast/yast-iscsi-client/pull/132)).
  * **YaST integration with Plasma 6:** Updated the YaST `.desktop` file location to ensure proper integration with KDE System Settings in Plasma 6, making it easily accessible to users ([pull request](https://github.com/yast/yast-control-center/pull/60)).

**Website and Documentation Updates**

  * **Fixing anchor link scrolling:** Addressed an issue where headings were hidden behind the floating title bar when using anchor links on the YaST blog. This improvement enhances navigation and readability ([pull request](https://github.com/yast/yast.github.io/pull/372)). You can see the improvement in action by comparing the following screenshots:
    * Before: <img src="https://github.com/user-attachments/assets/702b0bfd-e567-4ee9-a176-b8ad20baee70" alt="yast_blog_broken">
    * After: <img src="https://github.com/user-attachments/assets/2e277f9a-d7fa-494e-b448-4f6fe73c5bd3" alt="yast_blog_fixed">.
  * **Improved WSL testing documentation:** We've updated our documentation for testing YaST in the Windows Subsystem for Linux (WSL). This includes information on installing WSL, testing firstboot, creating a testing APPX, and more. You can find the updated documentation here: [https://github.com/yast/yast-firstboot/blob/master/doc/testing_wsl.md]

**Agama News**

*  **Agama has its own blog!**  Keep up with the latest news and developments from the Agama project by visiting their new blog at [https://agama-project.github.io/blog](https://agama-project.github.io/blog).

**Behind the Scenes**

  * **Moving sources for automatic package submission:** We've moved the sources of container definition for automatic package submission from OBS to GitHub to simplify maintenance and synchronization ([pull request](https://github.com/yast/ci-yast-rake-container/pull/1)).

**Thank You to Our Contributors!**

A big thank you to all the contributors who reported issues, submitted patches, and helped us make YaST even better. Your feedback and support are invaluable!

Stay tuned for more updates as we continue to enhance YaST and provide you with the best possible system administration experience.
