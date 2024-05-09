# Code of Conduct for This Repostory
If I verify a reported Code of Conduct violation, my policy is:

- Contributors are allowed to make patches only to the main branch, unless an additional branch is involved. This policy applies to the implementation of custom features/options, updated features/options, and grammar errors.

- uYouEnhanced does not support Localization pull requests. While it may seem like a sudden change, maintaining localization becomes challenging when the branch needs to be reset due in order to push to the latest changes from qnblackcat/uYouPlus repository. Therefore, it is difficult to preserve any localization changes that were added on uYouEnhanced since the fork/branch can get reset and takes too long to add them all back.

- The use of the name `uYouPlusExtra` is prohibited. The correct and updated name for this repository is `uYouEnhanced`.
  - if there is a tweak named or have the description of the word `uYouPlusExtra` then please do check it out before you interact with it or use it.

- Users who fork this repository, utilize it in actions, or build it from the repository on Git are prohibited from releasing .ipa files on their forked repositories. This restriction is in place to comply with the following https://enterprise.githubsupport.com/attachments/token/1u4kyYJnjA8HZTPMXOGBhRk4Q/?, also, preventing any potential legal issues. If a user violates this rule by including an .ipa file in their GitHub release publicly, appropriate actions will be taken from either the tweak developer or Google since .ipa's aren't allowed, they have the rights to do that. I apologize but it's the only way keep the repo from getting taken down.
**Simpiflied Version:** when building the ipa from your forked repository of uYouEnhanced, please do not upload and publish any .ipa files or I will have to do a request to take it down.

<details>
  <summary>Exclusive Rule for the original uYouPlus devs ⬇️</summary>
- Devs **qnblackcat** and **PoomSmart** are not allowed to use any new or changed code from the uYouEnhanced fork (excludes **AppIconOptionsController.m** & **AppIconOptionsController.h**) unless it is absolutely necessary. Breaking this rule may result in consequences like access revocation. it is strictly forbidden to publicly share or showcase the content of this policy on any social media platforms. This rule is in place to protect any of the rejected features in uYouEnhanced, refering to (LowContrastMode, Hide Shadow Overlay Button, YTHoldForSpeed & etc.)
To prevent conflicts and misunderstandings related to donations, all users should use code from the uYouEnhanced fork responsibly and honor the permissions and restrictions provided by the project administrators and tweak developers. Failure to do so may result in access revocation.
</details>

## uYouEnhanced Version Info

this following version of the uYouEnhanced Tweak is currently supported with feature updates.

| Developer(s) | Version | LTS Support | YT Version Supported | App Stability | uYou Functionality | uYouEnhanced Functionality |
|  - | - | - | - | - | - | - |
| MiRO92(uYou) & arichornlover(uYouEnhanced) | [latest](https://github.com/arichornlover/uYouEnhanced/releases/latest) | ✅ | ✅ | Stable | Fully functional | Change App Icon isn't functional, Timestamping url isn't functional |


## uYouEnhanced Branches Info
| Branche(s) | About |
|  - | - |
| `main` | The Default and Maintained Branch of uYouEnhanced. |
| `main-beta` | The Branch that is used for whenever Refreshing/Resetting the `main` branch. |
| `main-16.42.3LTS` | This Branch is an older version of `main` and includes outdated code for v16.42.3. This Version is discontinued but could still work in some cases. |
| `main-nightly` | The Branch that is similar to `main` but adds experimental features like the tweak ‘YouTimeStamp‘ and other content in the app. |
