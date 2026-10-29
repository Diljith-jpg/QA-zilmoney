# OCW-24680 — Language setting not applied after update

- Type: Task · Priority: Medium · Status: In QA · Dev: hari sankar · Reporter: Nihad
- Test link: https://ocw-24680-hari.web.ocw.sebipay.com (branch OCW-24680-HARI)
- Loom: https://www.loom.com/share/78f0069510ab4ed79816d0d00cd7f1c4

## Required changes
- Rename the Settings field "Language" to "Check Amount-in-Words Language".
- Keep the existing English and French options.
- Add a tooltip. Suggested text: "Select the language used to write the check amount in words. This setting does not change the application language."

## Expected result
Users understand that English/French only changes how the check amount is written in words, not the app UI language.

## Code locations (staging baseline)
- V3: src/app/modules/user/user-v2/components/general-settings/general-settings.component.html (label "Language", options en/fr)
- V4: src/app/modules/user-v4/components/v4-general-settings/v4-general-settings.component.html
