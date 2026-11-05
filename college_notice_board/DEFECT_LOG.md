# Defect Log

Add a row every time you find a bug while testing. Do not delete fixed rows; mark them Fixed.

| ID | Where | What happened | Steps to reproduce | Fixed? |
| --- | --- | --- | --- | --- |
| D1 | (example) Form | (example) Save worked with only spaces in the title | 1. Open Post notice. 2. Type spaces in Title. 3. Tap Save. | Yes, trimmed before validating |

## Test checklist (from requirement GP 8)

Tick each one after testing on the physical phone, and log any bug you find above.

- [ ] Empty input in every form field
- [ ] Very long title, description and name
- [ ] No internet connection (airplane mode): app still works
- [ ] Repeated fast taps on a notice, the Post notice button, and Save
- [ ] Phone turned sideways on all four screens
- [ ] Delete the last notice: empty message shows
- [ ] Filter to a department with no notices: message shows
- [ ] Close the app fully and reopen: notices are still there
